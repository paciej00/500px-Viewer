//
//  AllegriaDi500pxTests.swift
//  AllegriaDi500pxTests
//
//  Created by Paciej on 18/04/15.
//
//

import Quick
import Nimble
import AllegriaDi500px

class MainViewControllerSpec: QuickSpec {
    override func spec() {
        
        describe("MainViewController") {
            
            var sut: MainViewController!
            
            beforeEach {
                sut = MainViewController()
            }
            
            afterEach{
                sut = nil
            }
            
            context("tapping") {
                
                beforeEach {
                    UIApplication.sharedApplication().keyWindow?.rootViewController = UINavigationController(rootViewController: sut)
                }
                
                describe("the popular button") {
                    
                    beforeEach{
                        sut.popularButton.sendActionsForControlEvents(.TouchUpInside)
                    }
                    
                    it("should show photo list") {
                        expect(sut.navigationController?.topViewController).toEventually(beAKindOf(PhotoListViewController))
                    }
                    
                    it("should show photo list with popular feature") {
                        expect(sut.navigationController?.topViewController.valueForKey("feature") as? String).toEventually(equal("popular"))
                    }
                }
                
                describe("the editors button") {
                    
                    beforeEach{
                        sut.editorsButton.sendActionsForControlEvents(.TouchUpInside)
                    }
                    
                    it("should show photo list") {
                        expect(sut.navigationController?.topViewController).toEventually(beAKindOf(PhotoListViewController))
                    }
                    
                    it("should show photo list with editors feature") {
                        expect(sut.navigationController?.topViewController.valueForKey("feature") as? String).toEventually(equal("editors"))
                    }
                }
                
                describe("the upcoming button") {
                    
                    beforeEach{
                        sut.upcomingButton.sendActionsForControlEvents(.TouchUpInside)
                    }
                    
                    it("should show photo list") {
                        expect(sut.navigationController?.topViewController).toEventually(beAKindOf(PhotoListViewController))
                    }
                    
                    it("should show photo list with upcoming feature") {
                        expect(sut.navigationController?.topViewController.valueForKey("feature") as? String).toEventually(equal("upcoming"))
                    }
                }
            }
        }
    }
}
