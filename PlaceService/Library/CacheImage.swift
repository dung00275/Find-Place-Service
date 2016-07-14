//
//  CacheImage.swift
//  PlaceService
//
//  Created by Dung Vu on 7/14/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit

public enum ImageResult {
    case Success(image: UIImage?)
    case Fail(error: NSError)
}


public typealias DownloadImageCompletion = (result: ImageResult) -> Void

class CacheImage {
    
    static let sharedInstance = CacheImage()
    
    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        let queue = OperationQueue()
        queue.name = "CacheImage.Download"
        queue.qualityOfService = .utility
        
        let newSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: queue)
        return newSession
    }()
    
    lazy var cache: Cache = Cache<NSString, NSObject>()
    
    // Download
    func download(fromURL url: URL, completion: DownloadImageCompletion) -> URLSessionDownloadTask? {
        let nameImage = url.lastPathComponent ?? ""
        // Tracking in cache
        if let image = self.cache.object(forKey: nameImage ?? "") as? UIImage {
            completion(result: .Success(image: image))
            return nil
        }
        
        let fileManager = FileManager.default
        if let fileCacheURL = try? URL.cacheURL()?.appendingPathComponent(nameImage) where fileManager.fileExistAtURL(url: fileCacheURL)  {
            let image = UIImage(contensOfURL: fileCacheURL)?.scaledToSize(toSize: CGSize(width: 20, height: 20))
            if image != nil {
                self.cache.setObject(image!, forKey: nameImage)
            }
            DispatchQueue.main.async(execute: {
                completion(result: .Success(image: image))
            })
            
            return nil
        }
        
        
        let task = session.downloadTask(with: url) { [weak self](locationPath, response, error) in
            if let error = error {
                DispatchQueue.main.async(execute: {
                    completion(result: .Fail(error: error))
                })
            }else {
                // Move to cache
                DispatchQueue.global(attributes: .qosBackground).sync(execute: {
                    let image = UIImage(contensOfURL: locationPath)?.scaledToSize(toSize: CGSize(width: 20, height: 20))
                    
                    if image != nil {
                        self?.cache.setObject(image!, forKey: nameImage)
                    }
                    let fileCacheURL = try? URL.cacheURL()?.appendingPathComponent(nameImage)
                    if let locationPath = locationPath, cacheUrl = fileCacheURL where cacheUrl != nil {
                        do {
                            try fileManager.moveItem(at: locationPath, to: cacheUrl!)
                        }catch let errorMove as NSError{
                            print(errorMove.localizedDescription)
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        completion(result: .Success(image: image))
                    })
                })
            }
        }
        task.resume()
        return task
    }
}

extension UIImage {
    func scaledToSize(toSize size:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension URL {
    static func cacheURL() -> URL?{
        return FileManager.default.urlsForDirectory(.cachesDirectory, inDomains: .userDomainMask).last
    }
}

extension FileManager {
    func fileExistAtURL(url: URL?) -> Bool {
        guard let path = url?.path else {
            return false
        }
        return self.fileExists(atPath: path)
    }
}


extension UIImage{
    convenience init?(contensOfURL url: URL?) {
        guard let path = url?.path else {
            return nil
        }
        self.init(contentsOfFile: path)
    }
}

