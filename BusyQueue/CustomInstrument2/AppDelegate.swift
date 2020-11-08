//
//  AppDelegate.swift
//  CustomInstrument2
//
//  Created by Marin Todorov on 4/19/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import UIKit
import TimelaneCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var smileDetector: SmileDetector!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Timelane.defaultLogger = Timelane.Loggers.disabled

        smileDetector = try! SmileDetector { isSmiling in
            Timelane.defaultLogger = isSmiling
              ? Timelane.Loggers.timelaneInstrument
              : Timelane.Loggers.disabled
        }
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}
