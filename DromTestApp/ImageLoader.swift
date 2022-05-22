//
//  ImageLoader.swift
//  DromTestApp
//
//  Created by Владимир on 22.05.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case emptyData
}

class ImageLoader {    
    private let imagesCache = NSCache<NSString, NSData>()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    /**
     Stops all downloads tasks and clears the cache
     */
    func clearCache() {
        imagesCache.removeAllObjects()
        runningRequests.forEach { item in
            item.value.cancel()
        }
        runningRequests.removeAll()
    }
    
    /**
     Cancel task by identifier
     
     - Parameters:
        - uuid: Unique identifier of the task to cancel
     */
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
    
    /**
     Load image by URL
     
     - Parameters:
        - url: The URL for the download image.
        - completion: The completion handler to call when the load request is complete.
     This block takes a single Result parameter that contains Data or Error.

     - Returns: Unique task identifier
    */
    func loadImage(_ url: String, _ completion: @escaping (Result<Data, Error>) -> Void) -> UUID? {
        let cacheID = NSString(string: url)
        
        if let cachedData = imagesCache.object(forKey: cacheID) {
            completion(.success((cachedData as Data)))
            print("get from cache by url - \(url)")
        } else if let url = URL(string: url) {
            let uuid = UUID()
            
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad
            request.httpMethod = "get"
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                defer { self?.runningRequests.removeValue(forKey: uuid) }
                guard let data = data else {
                    print("download failed by url - \(url)")
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(NetworkError.emptyData))
                    }
                    return
                }
                print("download successful by url - \(url)")
                self?.imagesCache.setObject(data as NSData, forKey: cacheID)
                completion(.success(data))
            }
            
            task.resume()
            runningRequests[uuid] = task
            return uuid
        }
        return nil
    }
}
