//
//  FeedReaderError.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/13/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import Foundation

enum FeedReaderError: Error {
    case networkingError(Error)
    case parsingError(Error)
    case noData
}

extension FeedReaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkingError(let error):
            return error.localizedDescription
        case .parsingError(let error):
            return error.localizedDescription
        case .noData:
            return NSLocalizedString("No data was returned from the server.", comment: "error message")
        }
    }
}
