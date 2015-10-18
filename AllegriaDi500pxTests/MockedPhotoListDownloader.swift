//
//  MockedPhotoListDownloader.swift
//  AllegriaDi500px
//
//  Created by Paciej on 26/04/15.
//
//

import AllegriaDi500px

class MockedPhotoListDownloader: PhotoListDownloader {
    
    init() {
        super.init(session: MockedSession())
    }
    
    var requestedPage: Int?
    var requestedFeature: String?
    override func getPhotoList(feature: String, page: Int?) {
        requestedFeature = feature
        requestedPage = page
    }
}
