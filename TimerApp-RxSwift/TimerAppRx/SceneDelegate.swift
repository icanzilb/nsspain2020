//
//  SceneDelegate.swift
//  TimerApp
//
//  Created by Marin Todorov on 4/5/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Create a timer model with default duration of 10s.
        let viewModel = TimerViewModel(totalTime: 10)
        
        // Create the timer view with the said model.
        let timerView = TimerView(
            viewModel: viewModel,
            start: {
                viewModel.activate()
            }
        )

        // Show the view on screen
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: timerView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
