//
//  SceneDelegate.swift
//  NGCIKMeansExample
//
//  Created by Noah Gilmore on 6/26/20.
//

import UIKit
import SwiftUI
import CoreImage

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {

            let image = UIImage(named: "example")!
            let ciImage = CIImage(image: image)!

            guard let kMeansFilter = CIFilter(name: "CIKMeans") else {
               fatalError("Could not initialize `CIKMeans` filter.")
            }

            kMeansFilter.setValue(ciImage, forKey: kCIInputImageKey)
            kMeansFilter.setValue(CIVector(cgRect: ciImage.extent), forKey: "inputExtent")
            kMeansFilter.setValue(2, forKey: "inputCount")
            kMeansFilter.setValue(10, forKey: "inputPasses")
            kMeansFilter.setValue(NSNumber(value: true), forKey: "inputPerceptual")
            kMeansFilter.setValue(CIImage(color: CIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)).cropped(to: CGRect(x: 0, y: 0, width: 1, height: 1)), forKey: "inputMeans")

            let meansOutputImage = kMeansFilter.outputImage!
            print("Output image: \(meansOutputImage)")

            let palettizeFilter = CIFilter(name: "CIPalettize")!
            palettizeFilter.setValue(ciImage, forKey: "inputImage")
            palettizeFilter.setValue(meansOutputImage, forKey: "inputPaletteImage")
            palettizeFilter.setValue(0, forKey: "inputPerceptual")

            let palettizeOutput = palettizeFilter.outputImage!.cropped(to: CGRect(x: 0, y: 0, width: 500, height: 500))

            print("Palete output: \(palettizeOutput)")

            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: VStack {
                Image(uiImage: UIImage(ciImage: palettizeOutput))
                Text("Image above")
            }.background(Color.red))
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

