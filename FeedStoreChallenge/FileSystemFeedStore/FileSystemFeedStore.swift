//
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public final class FileSystemFeedStore: FeedStore {
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        let cache = Cache(feed: feed.map(FileSystemFeedImage.init), timestamp: timestamp)
        let encoded = try! JSONEncoder().encode(cache)
        try! encoded.write(to: storeURL)
        
        completion(nil)
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
    }
    
    public init() {}
    
    // MARK: - Private
    
    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("image-feed.store")
    
    private struct Cache: Codable {
        let feed: [FileSystemFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            feed.map { $0.local }
        }
    }
    
    private struct FileSystemFeedImage: Codable {
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
