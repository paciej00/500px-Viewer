//
//  PhotoDetailsViewControllerSpec.swift
//  AllegriaDi500px
//
//  Created by Paciej on 24/04/15.
//
//

import Quick
import Nimble
import AllegriaDi500px

class PhotoDetailsViewControllerSpec: QuickSpec {
    override func spec() {
        
        describe("PhotoDetailsViewController") {
            
            var sut: PhotoDetailsViewController!
            var photo: MockedPhoto!
            var photoDownloader: MockedPhotoDownloader!
            var data: NSData!
            
            beforeEach {
                photo = MockedPhoto()
                photoDownloader = MockedPhotoDownloader()
                data = {
                        let path =
                    NSBundle(forClass: PhotoDetailsViewControllerSpec.self).pathForResource("photoImage", ofType: "jpeg")
                        return NSData(contentsOfFile: path!, options: nil, error: nil)
                    }()
            }
            
            afterEach {
                sut = nil
                photo = nil
                photoDownloader = nil
                data = nil
            }

            context("generally") {
                
                beforeEach {
                    sut = PhotoDetailsViewController(photo: nil, photoDownloader: photoDownloader)
                }
                
                context("when photo is set") {
                    
                    beforeEach {
                        photo.data = data
                        sut.photo = photo
                    }
                    
                    it("should display photo name") {
                        expect(sut.nameLabel.text).to(equal(photo.name))
                    }
                    
                    it("should display photo rating") {
                        expect(sut.ratingLabel.text).to(equal("\(photo.rating)"))
                    }
                    
                    it("should display photo image") {
                        expect(sut.imageView.image).to(beAKindOf(UIImage))
                    }
                }
            }
            
            context("when initialized with photo without image") {
                
                beforeEach {
                    sut = PhotoDetailsViewController(photo: photo, photoDownloader: photoDownloader)
                }
                
                context("when view loaded") {
                    
                    beforeEach {
                        sut.viewDidLoad()
                    }
                    
                    it("should download photo") {
                        expect(photoDownloader.requestedURL).to(equal(photo.imageURL))
                    }
                }
            
                context("when photo download finishes") {
                    
                    beforeEach {
                        sut.photoDownloader(photoDownloader, didDownloadPhoto: data, fromURL: photo.imageURL)
                    }

                    it("should set data for photo") {
                        expect(photo.data).to(equal(data))
                    }
                    
                    it("should display image") {
                        expect(sut.imageView.image).to(beAKindOf(UIImage))
                    }
                }
            }
            
            
            context("when initialized with photo with image") {
                
                beforeEach {
                    photo.data = data
                    sut = PhotoDetailsViewController(photo: photo, photoDownloader: photoDownloader)
                }
                
                context("when view loaded") {
                    
                    beforeEach{
                        sut.viewDidLoad()
                    }
                    
                    it("should display name") {
                        expect(sut.nameLabel.text).to(equal(photo.name))
                    }
                    
                    it("should display rating") {
                        expect(sut.ratingLabel.text).to(equal("\(photo.rating)"))
                    }
                }
                
                context("when view appeared") {
                    
                    beforeEach{
                        sut.viewDidAppear(false)
                    }
                    
                    it("should display image") {
                        expect(sut.imageView.image).to(beAKindOf(UIImage))
                    }
                }
            }
        }
    }
}
