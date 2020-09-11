//
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

private struct InMemoryFeed {
    let images: [LocalFeedImage]
    let timestamp: Date
}

public final class InMemoryFeedStore: FeedStore {
    private var feed: InMemoryFeed?
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        feed = nil
        
        completion(nil)
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        self.feed = InMemoryFeed(images: feed, timestamp: timestamp)
        
        completion(nil)
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        if feed == nil {
            completion(.empty)
        } else {
            feed.map { completion(.found(feed: $0.images, timestamp: $0.timestamp)) }
        }
    }
    
    public init() {}
}
