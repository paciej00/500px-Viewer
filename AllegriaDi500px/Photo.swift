//
//  Photo.swift
//  AllegriaDi500px
//
//  Created by Paciej on 18/04/15.
//
//

import Foundation

/**
*  Class represetns photo data downloaded from 500px API
*/
public class Photo {
    
    //MARK: - public properties
    public let identifier: Int
    public let name: String
    public let rating: Double
    public var imageURL: String
    public var data: NSData?
    
    //MARK: - initialization
    public init(identifier: Int, name: String, rating: Double, imageURL: String) {
        self.identifier = identifier
        self.name = name
        self.rating = rating
        self.imageURL = imageURL
    }
    
    //MARK: - public methods
    public func clearData() {
        data = nil
    }
    
}

//MARK: - ==
extension Photo: Equatable {}
public func ==(lhs: Photo, rhs: Photo) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.name == rhs.name && lhs.rating == rhs.rating && lhs.imageURL == rhs.imageURL && lhs.data == rhs.data
}
