//
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public final class UserDefaultsFeedStore: FeedStore {
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        defaults.removeObject(forKey: key)
        
        completion(nil)
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        let cache = Cache(feed: feed.map(UserDefaultsFeedImage.init), timestamp: timestamp)
        let feedData = try! JSONEncoder().encode(cache)
        defaults.set(feedData, forKey: key)
        
        completion(nil)
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        guard let feedData = defaults.object(forKey: key) as? Data
            else { return completion(.empty) }
        
        let cache = try! JSONDecoder().decode(Cache.self, from: feedData)
        
        completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
    }
    
    public init(key: String) {
        self.key = key
    }
    
    // MARK: - Private
    
    private let defaults = UserDefaults.standard
    private let key: String
    
    private struct Cache: Codable {
        let feed: [UserDefaultsFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            feed.map { $0.local }
        }
    }
    
    private struct UserDefaultsFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL
        
        init(image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
        
        var local: LocalFeedImage {
            LocalFeedImage(id: self.id, description: self.description, location: self.location, url: self.url)
        }
    }
}
