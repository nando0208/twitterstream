//
//  AppDelegate.swift
//  twitterstream
//
//  Created by Fernando Ferreira on 04/04/18.
//  Copyright © 2018 Fernando Ferreira. All rights reserved.
//

import UIKit
import TwitterKit

// You need to create a app on https://apps.twitter.com/
// to get a Consumer Key and a Consumer Secret Key
let consumerKey = ""
let consumerSecretKey = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        TWTRTwitter.sharedInstance().start(withConsumerKey: consumerKey,
                                           consumerSecret: consumerSecretKey)

        window?.rootViewController = LoginRouter.presentLoginModule()

        return true
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        return true
    }

}
