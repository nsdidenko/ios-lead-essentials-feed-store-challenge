//
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public final class UserDefaultsFeedStore: FeedStore {
    private struct Cache: Codable {
        let images: [LocalFeedImage]
        let timestamp: Date
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        let cache = Cache(images: feed, timestamp: timestamp)
        let feedData = try! JSONEncoder().encode(cache)
        UserDefaults.standard.set(feedData, forKey: "Feed")
        
        completion(nil)
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        guard let feedData = UserDefaults.standard.object(forKey: "Feed") as? Data
            else { return completion(.empty) }
        
        let cache = try! JSONDecoder().decode(Cache.self, from: feedData)
        
        completion(.found(feed: cache.images, timestamp: cache.timestamp))
    }
    
    public init() {}
}
