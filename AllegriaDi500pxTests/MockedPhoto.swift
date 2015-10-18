//
//  MockedPhoto.swift
//  AllegriaDi500px
//
//  Created by Paciej on 26/04/15.
//
//

import AllegriaDi500px

class MockedPhoto: Photo {
    init() {
        super.init(identifier: 1, name: "mocked name", rating: 100, imageURL: "http://mocked.url.com")
    }
}
