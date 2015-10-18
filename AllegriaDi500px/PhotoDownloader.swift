//
//  PhotoDownloader.swift
//  AllegriaDi500px
//
//  Created by Paciej on 19/04/15.
//
//

import Foundation

//MARK: - PhotoDownloaderDelegate
protocol PhotoDownloaderDelegate: class {
    func photoDownloader(_: PhotoDownloader, didDownloadPhoto data: NSData, fromURL url: String?)
    func photoDownloader(_: PhotoDownloader, didFailToDownloadPhoto error: NSError, fromURL url: String?)
}

/**
*  https://github.com/onevcat/Kingfisher could be used to acheive goal of the Photo Downloader.
*/

/**
*  Class is intended to download binary data from a given URL to be represented as image.
*/
//MARK: - PhotoDownloader
public class PhotoDownloader: NSObject {
    
    //MARK: - internal properties
    let session: NSURLSession
    weak var photoDownloaderDelegate: PhotoDownloaderDelegate? // Called on Main Queue
    var currentTasks = [NSURLSessionDataTask]()
    var currentTasksLock = NSLock()
    
    //MARK: - initialization
    public init(session: NSURLSession) {
        self.session = session
        super.init()
    }
    
    //MARK: - public methods
    /**
    Method downloads image data from a given url
    
    :param: url url from which to download binary data
    */
    public func getPhoto(fromURL url: NSURL?) {
        if let url = url {
            if taskExists(url) == false {
                let task = session.dataTaskWithURL(url) { [weak self] (data, response, error) in
                    if let error = error {
                        dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                            self?.photoDownloaderDelegate?.photoDownloader(self!, didFailToDownloadPhoto: error, fromURL: nil)
                            })
                        self?.currentTasksLock.lock()
                        self?.currentTasks = self!.existingTasksWithFilteredErrors()
                        self?.currentTasksLock.unlock()
                    } else {
                        let url = response.URL?.absoluteString
                        dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                            self?.photoDownloaderDelegate?.photoDownloader(self!, didDownloadPhoto: data, fromURL: url)
                            })
                        self?.currentTasksLock.lock()
                        self?.currentTasks = self!.existingTasks(filterURL: response.URL)
                        self?.currentTasksLock.unlock()
                    }
                }
                task.resume()
                self.currentTasksLock.lock()
                currentTasks.append(task)
                self.currentTasksLock.unlock()
            }
            
        }
    }
    
    //MARK: - internal methods
    /**
    Method checks if NSURLSessionDataTask objects for a given URL exist in the download queue and returns them.
    
    :param: url url for checking presence of a task
    
    :returns: filtered NSURLSessionDataTask objects or an empty table
    */
    func existingTasks(url: NSURL) -> [NSURLSessionDataTask] {
        return currentTasks.filter { (task) -> Bool in
            task.originalRequest.URL == url
        }
    }
    
    /**
    Method returns existing tasks filtered out by the given url.
    
    :param: url url to filter from existing tasks
    
    :returns: filtered NSURLSessionDataTask objects or an empty table
    */
    func existingTasks(filterURL url: NSURL?) -> [NSURLSessionDataTask] {
        if let url = url {
            return currentTasks.filter { (task) -> Bool in
                task.originalRequest.URL != url
            }
        }
        return [NSURLSessionDataTask]()
    }
    
    /**
    Method returns existing tasks with filtered out errored tasks.
    
    :returns: filtered NSURLSessionDataTask objects or an empty table
    */
    func existingTasksWithFilteredErrors() -> [NSURLSessionDataTask] {
        return currentTasks.filter { (task) -> Bool in
            if let error = task.error {
                return true
            }
            return false
        }
    }
    
    /**
    Method checks if task of a given URL is present in the existingTasks queue.
    
    :param: url url to check for
    
    :returns: Bool value indicating presence or absence of task
    */
    func taskExists(url: NSURL) -> Bool {
        return existingTasks(url).count > 0
    }
    
    /**
    Clears data cached by NSURLSession object.
    */
    func clearCachedData() {
        session.configuration.URLCache?.removeAllCachedResponses()
    }
    
}
