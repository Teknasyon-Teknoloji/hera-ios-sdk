//
//  AppDelegate.swift
//  Hera
//
//  Created by engali94 on 01/20/2021.
//  Copyright (c) 2021 engali94. All rights reserved.
//

import UIKit
import Hera

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let env: HeraEnvironment
		#if DEBUG
		env = .sandbox
		#else
		env = .production
		#endif
		
		let userProperties = HeraUserProperties(
			deviceID: "12345675",
			country: "tr",
			language: "tr-tr",
			advertiseAttributions: [:], // can be obtained from deepwall
			extraData: [:] // Note: any extra json info you want to sent
		)
		
        Hera
			.shared
			.initialize(apiKey: "YOUR_APP_KEY", userProperties: userProperties, environment: env)
		
        return true
    }
}
