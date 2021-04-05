//
//  AppDelegate.swift
//  Covaid
//
//  Created by Dr.Drake on 5/19/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import Firebase
import GoogleSignIn
import TwitterKit
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        IQKeyboardManager.shared.enable = true
        //Facebook
                
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: Covaid.twitterKey, consumerSecret: Covaid.twitterSecret)
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        Stripe.setDefaultPublishableKey(Covaid.stripe)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let loginVc = LoginViewController()
        
        window?.rootViewController = loginVc
        window?.makeKeyAndVisible()
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        GIDSignIn.sharedInstance()?.handle(url)
        
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options) || ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    

    // MARK: UISceneSession Lifecycle
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    override init() {
        FirebaseApp.configure()
    }
}

