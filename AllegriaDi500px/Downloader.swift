//
//  PhotoDownloader.swift
//  AllegriaDi500px
//
//  Created by Paciej on 18/04/15.
//
//

import Foundation

//MARK: - DownloaderDelegate
public protocol DownloaderDelegate: class {
    func downloader(_: Downloader, didDownloadData data: NSData)
    func downloader(_: Downloader, didFailToDownloadDataWithError error: NSError)
}

/**
*  Class is a generic data downloader that uses NSURLSession to download data from a given base URL. Completion handlers are used when communicating with NSURLSession object. When download finishes, downloader callbacks are called on session's queue.
*/
//MARK: - Downloader
public class Downloader: NSObject {
    
    //MARK: - internal properties
    let session: NSURLSession
    let baseURL: String
    weak var downloaderDelegate: DownloaderDelegate?// Called on Session's Queue

    //MARK: - initializtion
    init(session: NSURLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
        super.init()
    }

    //MARK: - internal methods
    /**
    Method tells NSURLSession to download data from a base url with appended params. Be sure that provided parameter names and values make accepted query string by the endpoint.
    
    :param: params parameters appended to URL as query string
    */
    func getDataFromBaseURL(#params: [String: String]) {
        if let url = createURL(params: params) {
            let task = session.dataTaskWithURL(url) { [weak self] (data, response, error) in
                if let error = error {
                    self?.downloaderDelegate?.downloader(self!, didFailToDownloadDataWithError: error)
                } else {
                    self?.downloaderDelegate?.downloader(self!, didDownloadData: data)
                }
            }
            task.resume()
        }
    }
    
    /**
    Method tries to craete URL with query string from given paramaters
    
    :param: params parameters appended to URL as query string
    
    :returns: NSURL object or nil
    */
    func createURL(#params: [String: String]) -> NSURL? {
        var url = baseURL
        if params.count > 0 {
            url += "?"
            for (param, value) in params {
                url += "&" + param + "=" + value
            }
        }
        return NSURL(string: url)
    }
    
    /**
    Clears data cached by NSURLSession object.
    */
    func clearCachedData() {
        session.configuration.URLCache?.removeAllCachedResponses()
    }
    
}
