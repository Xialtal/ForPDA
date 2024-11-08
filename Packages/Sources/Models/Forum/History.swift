//
//  History.swift
//  ForPDA
//
//  Created by Xialtal on 8.11.24.
//

import Foundation

public struct History: Codable, Sendable, Hashable {
    public let seenDate: Date
    public let topic: TopicInfo
    
    public init(seenDate: Date, topic: TopicInfo) {
        self.seenDate = seenDate
        self.topic = topic
    }
}

public extension History {
    static let mock = [
        History(
            seenDate: Date.now,
            topic: TopicInfo.mock
        ),
        History(
            seenDate: Date(timeIntervalSince1970: 1731074733),
            topic: TopicInfo.mock
        ),
        History(
            seenDate: Date(timeIntervalSince1970: 1725706884),
            topic: TopicInfo.mock
        )
    ]
}

