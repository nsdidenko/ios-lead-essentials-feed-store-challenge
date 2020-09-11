//
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public final class InMemoryFeedStore: FeedStore {
    private var images = [LocalFeedImage]()
    private var timestamp: Date?
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        images = []
        
        completion(nil)
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        self.images = feed
        self.timestamp = timestamp
        
        completion(nil)
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        if images.isEmpty {
            completion(.empty)
        } else {
            completion(.found(feed: images, timestamp: timestamp ?? Date()))
        }
    }
    
    public init() {}
}
