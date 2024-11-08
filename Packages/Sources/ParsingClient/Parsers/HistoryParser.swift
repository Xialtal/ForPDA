//
//  HistoryParser.swift
//  ForPDA
//
//  Created by Xialtal on 8.11.24.
//

import Foundation
import Models

public struct HistoryParser {
    public static func parse(rawString string: String) throws -> [History] {
        if let data = string.data(using: .utf8) {
            do {
                guard let array = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { throw ParsingError.failedToCastDataToAny }
                
                return (array[3] as! [[Any]]).map { history in
                    return History(
                        seenDate: Date(timeIntervalSince1970: history[8] as! TimeInterval),
                        topic: ForumParser.parseTopic(history)
                    )
                }
            } catch {
                throw ParsingError.failedToSerializeData(error)
            }
        } else {
            throw ParsingError.failedToCreateDataFromString
        }
    }
}
