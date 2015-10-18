//
//  PhotoListDownloader.swift
//  AllegriaDi500px
//
//  Created by Paciej on 19/04/15.
//
//

import Foundation

//MARK: - PhotoListDownloaderDelegate
public protocol PhotoListDownloaderDelegate {
    func photoListDownloader(_: PhotoListDownloader, didDownloadPhotos photos: [Photo], fromPage page: Int)
    func photoListDownloader(_: PhotoListDownloader, didFailToDownloadPhotos error: NSError?, fromPage page: Int?)
}

/**
*  Class is intended for downloading list of photos accessible via the 500px API filtered by the given feature. Object is a subclass of Downloader. Delegate callbacks are invoked on the Main  Queue.
*/
//MARK: - PhotoListDownloader
public class PhotoListDownloader: Downloader {
    
    //MARK: - internal interface
    var photoListDownloaderDelegate: PhotoListDownloaderDelegate? // Called on Main Queue
    var currentPage: Int?
    var currentPageLock = NSLock()
    
    //MARK: - initialization
    public init(session: NSURLSession) {
        super.init(session: session, baseURL: apiBaseURL)
        downloaderDelegate = self //This is a known bug that causes retain cycle. PhotoListDownloader should take a Downloader object as a dependancy instead of inheriting from it.
    }
    
    //MARK: - public methods
    /**
    Method downloads from 500px API list of photos of a given feature. If no page number is given, the first page of items is fetched.
    
    :param: feature name of feature of photos to download from API
    :param: page    page number of photos list to be dowloaded
    */
    public func getPhotoList(feature: String, page: Int?) {
        currentPageLock.lock()
        if currentPage != page {
            currentPage = page
            getDataFromBaseURL(params: params(feature, page: page))
        }
        currentPageLock.unlock()
    }
    
    //MARK: - internal methods
    /**
    Helper method that creates params dictionary for URL request
    
    :param: feature name of feature of photos
    :param: page    page number of photos list
    
    :returns: dictionary with String key and value
    */
    func params(feature: String, page: Int?) -> [String: String] {
        var pageString: String
        if let page = page {
            pageString = "\(page)"
        } else {
            pageString = "1"
        }
        return [
            apiConsumerKeyParamName: apiConsumerKey,
            apiFeatureParamName: feature,
            apiPageParamName: pageString
        ]
    }
    
}

//MARK: - DownloaderDelegate
extension PhotoListDownloader: DownloaderDelegate {
    public func downloader(downloader: Downloader, didDownloadData data: NSData) {
        
        var error: NSError?
        
        if let JSON = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSDictionary {
            var page = (JSON[apiResponsePageKey] as? Int)!
            var photos = [Photo]()
            
            for photo in (JSON[apiResponsePhotosKey] as? [NSDictionary])! {
                
                let identifier = photo[apiResponseIdKey] as? Int
                let name = photo[apiResponseNameKey] as? String
                let rating = photo[apiResponseRatingKey] as? Double
                let url = photo[apiResponseImageURLKey] as? String
                
                photos.append(Photo(identifier: identifier!, name: name!, rating: rating!, imageURL: url!))
            }
            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                self?.photoListDownloaderDelegate?.photoListDownloader(self!, didDownloadPhotos: photos, fromPage: page)
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                self?.photoListDownloaderDelegate?.photoListDownloader(self!, didFailToDownloadPhotos: error, fromPage: nil)
            })
        }
        currentPageLock.lock()
        currentPage = nil
        currentPageLock.unlock()
    }
    
    public func downloader(downloader: Downloader, didFailToDownloadDataWithError error: NSError) {
        dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
            self?.photoListDownloaderDelegate?.photoListDownloader(self!, didFailToDownloadPhotos: error, fromPage: nil)
        })
    }
    
}
