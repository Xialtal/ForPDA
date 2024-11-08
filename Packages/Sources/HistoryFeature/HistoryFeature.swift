//
//  HistoryFeature.swift
//  ForPDA
//
//  Created by Xialtal on 8.11.24.
//

import Foundation
import ComposableArchitecture
import APIClient
import Models

@Reducer
public struct HistoryFeature: Sendable {
    
    public init() {}
    
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        public var history: [HistorySorted] = []
        
        public init(
            history: [HistorySorted] = []
        ) {
            self.history = history
        }
    }
    
    // MARK: - Action
    
    public enum Action {
        case onTask
        case settingsButtonTapped
        case topicTapped(id: Int)
        
        case _historyResponse(Result<[History], any Error>)
    }
    
    // MARK: - Dependencies
    
    @Dependency(\.apiClient) private var apiClient
    
    // MARK: - Body
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onTask:
                return .run { send in
                    // TODO: Impl pagination
                    let result = await Result { try await apiClient.getHistory(page: 1, perPage: 20) }
                    await send(._historyResponse(result))
                }
                
            case .settingsButtonTapped, .topicTapped(_):
                return .none
                
            case let ._historyResponse(.success(response)):
                var groupedHistories: [Date: [TopicInfo]] = [:]
                
                let calendar = Calendar.current
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                for history in response {
                    let dateWithoutTime = calendar.startOfDay(for: history.seenDate)
                    
                    if groupedHistories[dateWithoutTime] != nil {
                        groupedHistories[dateWithoutTime]?.append(history.topic)
                    } else {
                        groupedHistories[dateWithoutTime] = [history.topic]
                    }
                }
                
                var sortedHistories: [HistorySorted] = []
                for (date, topics) in groupedHistories {
                    sortedHistories.append(HistorySorted(seenDate: date, topics: topics))
                }

                sortedHistories.sort { $0.seenDate > $1.seenDate }
                
                state.history = sortedHistories
                return .none
                
            case let ._historyResponse(.failure(error)):
                print(error)
                return .none
            }
        }
    }
}

public struct HistorySorted: Hashable {
    public let seenDate: Date
    public let topics: [TopicInfo]
    
    public init(seenDate: Date, topics: [TopicInfo]) {
        self.seenDate = seenDate
        self.topics = topics
    }
}
