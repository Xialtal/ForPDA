//
//  SettingsFeature.swift
//
//
//  Created by Ilia Lubianoi on 12.05.2024.
//

import UIKit
import ComposableArchitecture
import TCAExtensions

@Reducer
public struct SettingsFeature: Sendable {
    
    public init() {}
    
    // MARK: - Destinations
    
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<SettingsFeature.Action.Alert>)
    }
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        @Presents public var destination: Destination.State?
        
        public var appVersionAndBuild: String {
            let info = Bundle.main.infoDictionary
            let version = info?["CFBundleShortVersionString"] as? String ?? "-1"
            let build = info?["CFBundleVersion"] as? String ?? "-1"
            return "\(version) (\(build))"
        }
        
        public var currentLanguage: String {
            guard let identifier = Locale.current.language.languageCode?.identifier else { return "Unknown" }
            switch identifier {
            case "en": return "English"
            case "ru": return "Русский"
            default:   return "Unknown"
            }
        }
        
        public init(
            destination: Destination.State? = nil
        ) {
            self.destination = destination
        }
    }
    
    // MARK: - Action
    
    public enum Action {
        case languageButtonTapped
        case themeButtonTapped
        case safariExtensionButtonTapped
        case checkVersionsButtonTapped
        
        case destination(PresentationAction<Destination.Action>)
        public enum Alert: Equatable {
            case openSettings
        }
    }
    
    // MARK: - Dependencies
    
    @Dependency(\.openURL) var openURL
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .languageButtonTapped:
                return .run { _ in
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    await open(url: settingsURL)
                }
                
            case .themeButtonTapped:
                state.destination = .alert(.notImplemented)
                return .none
                
            case .safariExtensionButtonTapped:
                // TODO: Not working anymore, check other solutions
                // openURL(URL(string: "App-Prefs:SAFARI&path=WEB_EXTENSIONS")!)
                // state.destination = .alert(.safariExtension)
                state.destination = .alert(.notImplemented)
                return .none
                
            case .checkVersionsButtonTapped:
                return .run { _ in
                    // TODO: Move URL to models
                    await open(url: URL(string: "https://github.com/SubvertDev/ForPDA/releases/")!)
                }
                
            case .destination(.presented(.alert(.openSettings))):
                return .run { _ in
                    // TODO: Test on iOS 16/17
                    await open(url: URL(string: "App-Prefs:")!)
                }
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    private func open(url: URL) async {
        if #available(iOS 18, *) {
            Task { @MainActor in
                await UIApplication.shared.open(url)
            }
        } else {
            await openURL(url)
        }
    }
}

// MARK: - Alert Extensions

private extension AlertState where Action == SettingsFeature.Action.Alert {
    
    nonisolated(unsafe) static let safariExtension = AlertState {
        TextState("Instructions", bundle: .module)
    } actions: {
        ButtonState(action: .openSettings) {
            TextState("Open Settings", bundle: .module)
        }
        ButtonState(role: .cancel) {
            TextState("Cancel", bundle: .module)
        }
    } message: {
        TextState("You need to open Settings > Apps > Safari > Extensions > Open in ForPDA > Allow Extension", bundle: .module)
    }
}
