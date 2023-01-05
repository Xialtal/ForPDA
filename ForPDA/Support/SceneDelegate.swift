//
//  SceneDelegate.swift
//  ForPDA
//
//  Created by Subvert on 04.12.2022.
//

import UIKit
// import WebKit
import Nuke
import NukeAlamofirePlugin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    // var webView: WKWebView!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = PDATabBarController()
        self.window = window
        window.makeKeyAndVisible()
        
        let pipeline = ImagePipeline {
            $0.dataLoader = NukeAlamofirePlugin.AlamofireDataLoader()
            $0.imageCache = ImageCache.shared
        }

        ImagePipeline.shared = pipeline

        // let config = WKWebViewConfiguration()
        // config.dataDetectorTypes = []
        // config.suppressesIncrementalRendering = true
        // webView = WKWebView(frame: .zero, configuration: config)
        // webView.tag = 666
        // webView.navigationDelegate = self
        // window.addSubview(webView)
        
        // webView.load(URLRequest(url: URL(string: "https://4pda.to/")!))
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

}

//extension SceneDelegate: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print(#function)
//    }
//}