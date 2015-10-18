//
//  PhotoListViewControllerSpec.swift
//  AllegriaDi500px
//
//  Created by Paciej on 24/04/15.
//
//

import Quick
import Nimble
import AllegriaDi500px

class PhotoListViewControllerSpec: QuickSpec {
    override func spec() {
        
        describe("PhotoListViewController") {
            
            var sut: PhotoListViewController!
            var photoListDownloader: MockedPhotoListDownloader!
            var photoDownloader: MockedPhotoDownloader!
            
            let feature: String = "mocked feature"
            
            beforeEach {
                photoListDownloader = MockedPhotoListDownloader()
                photoDownloader = MockedPhotoDownloader()
                sut = PhotoListViewController(feature: feature, photoListDownloader: photoListDownloader, photoDownloader: photoDownloader)
            }
            
            afterEach {
                photoListDownloader = nil
                photoDownloader = nil
                sut = nil
            }
            
            context("when view loaded") {
                
                beforeEach {
                    sut.viewDidLoad()
                }
                
                it("should download list of photos for \(feature)") {
                    expect(photoListDownloader.requestedFeature).to(equal(feature))
                }
                
                it("should download first page of the list") {
                    expect(photoListDownloader.requestedPage!).to(equal(1))
                }
            }
            
            
            context("when list download finishes") {
                
                var photos = [MockedPhoto()]
                
                beforeEach {
                    sut.photoListDownloader(photoListDownloader, didDownloadPhotos: photos, fromPage: 1)
                }
                
                for photo in photos {
                    it("\(photo) is stored") {
                        expect(sut.photos).to(contain(photo))
                    }
                }
            }
            
            context("when photo download finishes") {
                
                var photo: MockedPhoto!
                var data: NSData!
                
                beforeEach {
                    photo = MockedPhoto()
                    data = NSData()
                    sut.photos.append(photo)
                    sut.photoDownloader(photoDownloader, didDownloadPhoto: data, fromURL: photo.imageURL)
                }
                
                it("should set data for photo") {
                    expect(photo.data).to(equal(data))
                }
            }
        }
    }
}
