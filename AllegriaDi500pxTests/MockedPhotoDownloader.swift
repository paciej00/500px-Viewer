//
//  MockedPhotoDownloader.swift
//  AllegriaDi500px
//
//  Created by Paciej on 26/04/15.
//
//

import Foundation
import AllegriaDi500px

class MockedPhotoDownloader: PhotoDownloader {
    init() {
        super.init(session: MockedSession())
    }
    
    var requestedURL: String?
    override func getPhoto(fromURL url: NSURL?) {
        if let url = url {
            requestedURL = url.absoluteString
        }
        
    }
}