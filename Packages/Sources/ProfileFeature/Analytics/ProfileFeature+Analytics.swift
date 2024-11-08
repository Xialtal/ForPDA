//
//  ProfileFeature+Analytics.swift
//  ForPDA
//
//  Created by Ilia Lubianoi on 23.08.2024.
//

import Foundation
import ComposableArchitecture
import AnalyticsClient

extension ProfileFeature {
    
    struct Analytics: Reducer {
        typealias State = ProfileFeature.State
        typealias Action = ProfileFeature.Action
        
        @Dependency(\.analyticsClient) var analyticsClient
        
        var body: some ReducerOf<Self> {
            Reduce { state, action in
                switch action {
                case .onTask, .alert:
                    break
                    
                case .settingsButtonTapped:
                    analyticsClient.log(ProfileEvent.settingsTapped)
                    
                case .logoutButtonTapped:
                    analyticsClient.log(ProfileEvent.logoutTapped)
                    analyticsClient.logout()
                    
                case let ._userResponse(.success(user)):
                    analyticsClient.log(ProfileEvent.userLoaded(user.id))
                    
                case ._userResponse(.failure):
                    analyticsClient.log(ProfileEvent.userLoadingFailed)
                }
                return .none
            }
        }
    }
}
