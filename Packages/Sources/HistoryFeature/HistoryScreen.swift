//
//  HistoryScreen.swift
//  ForPDA
//
//  Created by Xialtal on 8.11.24.
//

import SwiftUI
import ComposableArchitecture
import SFSafeSymbols
import SharedUI

public struct HistoryScreen: View {
    
    @Perception.Bindable public var store: StoreOf<HistoryFeature>
    @Environment(\.tintColor) private var tintColor
    
    public init(store: StoreOf<HistoryFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                Color.Background.primary
                    .ignoresSafeArea()
                
                List(store.history, id: \.hashValue) { history in
                    Section {
                        ForEach(history.topics) { topic in
                            HStack(spacing: 25) {
                                Row(title: topic.name, unread: topic.isUnread, action: {
                                    store.send(.topicTapped(id: topic.id))
                                })
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            .buttonStyle(.plain)
                            .frame(height: 60)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } header: {
                        Header(title: history.seenDate.formattedDateOnly())
                    }
                    .listRowBackground(Color.Background.teritary)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(Text("History", bundle: .module))
            .navigationBarTitleDisplayMode(.large)
            .task {
                store.send(.onTask)
            }
        }
    }
    
    // MARK: - Row
    
    @ViewBuilder
    private func Row(title: String, unread: Bool, action: @escaping () -> Void = {}) -> some View {
        HStack(spacing: 0) { // Hacky HStack to enable tap animations
            Button {
                action()
            } label: {
                HStack(spacing: 0) {
                    Text(title)
                        .font(.body)
                        .foregroundStyle(Color.Labels.primary)
                    
                    Spacer(minLength: 8)
                    
                    if unread {
                        Circle()
                            .font(.title2)
                            .foregroundStyle(tintColor)
                            .frame(width: 8)
                            .padding(.trailing, 12)
                    }
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .buttonStyle(.plain)
        .frame(height: 60)
    }
    
    // MARK: - Header
    
    @ViewBuilder
    private func Header(title: LocalizedStringKey) -> some View {
        Text(title, bundle: .module)
            .font(.subheadline)
            .foregroundStyle(Color.Labels.teritary)
            .textCase(nil)
            .offset(x: 0)
            .padding(.bottom, 4)
    }
}

// MARK: - Extensions

private extension Date {
    
    func formattedDateOnly() -> LocalizedStringKey {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"

        if Calendar.current.isDateInToday(self) {
            return LocalizedStringKey("Today")
        } else if Calendar.current.isDateInYesterday(self) {
            return LocalizedStringKey("Yesterday")
        }
        
        return LocalizedStringKey("\(formatter.string(from: self))")
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        HistoryScreen(
            store: Store(
                initialState: HistoryFeature.State()
            ) {
                HistoryFeature()
            }
        )
    }
}
