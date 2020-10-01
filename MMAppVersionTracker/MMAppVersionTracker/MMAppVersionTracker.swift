//
//  MMAppVersionTracker.swift
//  Eatmarna
//
//  Created by Mohammed Mir on 30/09/2020.
//  Copyright © 2020 Sejel Technology. All rights reserved.
//

import Foundation

import UIKit

enum CustomError: Error {
   case jsonReading
   case invalidIdentifires
   case invalidURL
   case invalidVersion
   case invalidAppName
}

class MMAppVersionTracker: NSObject {
    public static let shared = MMAppVersionTracker()

    var langCode = "en"
    
    func checkAppStoreVersion(isForceUpdate: Bool, languageCode : String) {
        self.langCode = languageCode
        do {
            //Get Bundle Identifire from Info.plist
            guard let bundleIdentifire = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
                print("No Bundle Info found.")
                throw CustomError.invalidIdentifires
            }
            
            // Build App Store URL
            guard let url = URL(string:"http://itunes.apple.com/lookup?bundleId=" + bundleIdentifire) else {
                print("Isse with generating URL.")
                throw CustomError.invalidURL
            }
            
            let serviceTask = URLSession.shared.dataTask(with: url) { (responseData, response, error) in
                
                do {
                    // Check error
                    if let error = error { throw error }
                    //Parse response
                    guard let data = responseData else { throw CustomError.jsonReading }
                    let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let itunes = ItunesAppInfo.init(fromDictionary: result as! [String : Any])
                    if let itunesResult = itunes.results.first {
                        
                        //Get Bundle Version from Info.plist
                        guard let appShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                            print("No Short Version Info found.")
                            throw CustomError.invalidVersion
                        }
                        
                        if appShortVersion < itunesResult.version {
                        
                            //Show Update alert
                            var message = ""
                            //Get Bundle Version from Info.plist
                            if self.langCode == "ar"{
                                message = "يوجد تحديث جديد لتطبيق إعتمرنا(\(itunesResult.version!)) متاح في متجر التطبيقات"
                            }else{
                                message = "Eatmarna has new version(\(itunesResult.version!)) available on App Store."

                            }
                            
                            
                            //Show Alert on main thread
                            DispatchQueue.main.async {
                                self.showUpdateAlert(message: message, appStoreURL: itunesResult.trackViewUrl, isForceUpdate: isForceUpdate)
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
            serviceTask.resume()
        } catch {
            print(error)
        }
    }
    
    func showUpdateAlert(message : String, appStoreURL: String, isForceUpdate: Bool) {
        
        let controller = UIAlertController(title: langCode == "ar" ? "يوجد تحديث" : "New Version", message: message, preferredStyle: .alert)
        
        //Optional Button
        if !isForceUpdate {
            controller.addAction(UIAlertAction(title: langCode == "ar" ? "لاحقا" : "Later", style: .cancel, handler: { (_) in }))
        }
        
        controller.addAction(UIAlertAction(title: langCode == "ar" ? "تحديث" : "Update", style: .default, handler: { (_) in
            guard let url = URL(string: appStoreURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }))
        
        UIApplication.shared.delegate?.window??.rootViewController?.present(controller, animated: true)
        
    }
}
