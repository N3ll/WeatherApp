//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Nelly Chakarova on 28/05/15.
//  Copyright (c) 2015 Nelly Chakarova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
//        println("background")
        ViewController.saveKeys()
    }


    func applicationWillTerminate(application: UIApplication) {
//        println("terminate")
       ViewController.saveKeys()
        
    }
}
//End of AppDelegate.swift class

