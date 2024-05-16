//
//  File.swift
//  
//
//  Created by Ilia Lubianoi on 09.04.2024.
//

import SwiftUI
import ComposableArchitecture
import NewsListFeature
import NewsFeature
import MenuFeature
import SettingsFeature

public struct AppView: View {
    
    @Perception.Bindable public var store: StoreOf<AppFeature>
    
    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                NewsListScreen(store: store.scope(state: \.newsList, action: \.newsList))
            } destination: { store in
                switch store.case {
                case let .news(store):
                    NewsScreen(store: store)
                    
                case let .menu(store):
                    MenuScreen(store: store)
                    
                case let .settings(store):
                    SettingsScreen(store: store)
                }
            }
        }
    }
}
