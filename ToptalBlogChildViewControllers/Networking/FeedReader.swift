//
//  FeedReader.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/13/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import Foundation

class FeedReader {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func loadFeed(completion: @escaping (Result<FeedWrapper, FeedReaderError>) -> ()) {
        let request = URLRequest(url: buildAPIURL())
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.networkingError(error)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                let parseResult = Result<FeedWrapper, Error> {
                    return try JSONDecoder().decode(FeedWrapper.self, from: data)
                }
                
                let result = parseResult.mapError({ FeedReaderError.parsingError($0) })
                completion(result)
            }
        }.resume()
    }
    
    private func buildAPIURL() -> URL {
        var urlComponents = URLComponents(string: "https://api.rss2json.com/v1/api.json")!
        let rssURLQueryItem = URLQueryItem(name: "rss_url", value: url.absoluteString)
        urlComponents.queryItems = [rssURLQueryItem]
        return urlComponents.url!
    }
    
    static let toptalBlog = FeedReader(url: URL(string: "https://www.toptal.com/blog.rss")!)
    static let toptalEngineeringBlog = FeedReader(url: URL(string: "https://www.toptal.com/developers/blog.rss")!)
}
