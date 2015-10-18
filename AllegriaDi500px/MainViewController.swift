//
//  MainViewController.swift
//  AllegriaDi500px
//
//  Created by Paciej on 18/04/15.
//
//

import UIKit

/**
*  Ekran główny: po wejściu do aplikacji powinien pojawić się ekran główny z trzema przyciskami, każdy z nich po naciśnięciu powinien otwierać listę zdjęć z określonym parametrem - "popular", "upcoming" oraz "editors".
    
    Szczegóły: https://github.com/500px/api-documentation/blob/master/endpoints/photo/GET_photos.md
*/

/**
*  View Controller used for selection of feature for items to be downloaded from 500px API.
*/
//MARK: - MainViewController
public class MainViewController: BaseViewController {
    
    //MARK: - public properties
    public let popularButton = UIButton()
    public let upcomingButton = UIButton()
    public let editorsButton = UIButton()
    
    //MARK: - initialization 
    public override init() {
        super.init()
        title = "500px"
        setupButtons()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    //MARK: - lifecycle
    public override func loadView() {
        super.loadView()
        view.addSubview(popularButton)
        view.addSubview(upcomingButton)
        view.addSubview(editorsButton)
    }
    
    //MARK: - public methods
    /**
    Method is an action for button tapped. Photo List of items with feature is shown.
    
    :param: sender button that invokes action, its title is taken as feature name
    */
    public func buttonTapped(sender:UIButton) {
        self.navigationController?.showViewController({
            let feature = sender.currentTitle!
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            sessionConfig.HTTPMaximumConnectionsPerHost = 1
            let photoListDownloaderSession = NSURLSession(configuration: sessionConfig)
            let photoListDownloader = PhotoListDownloader(session: photoListDownloaderSession)
            let photoDownloaderSession = NSURLSession(configuration: sessionConfig)
            let photoDownloader = PhotoDownloader(session: photoDownloaderSession)
            let photoListViewController = PhotoListViewController(feature: feature, photoListDownloader: photoListDownloader, photoDownloader: photoDownloader)
            return photoListViewController
            }(), sender: self)
    }
    
    //MARK: - internal methods
    override func setupConstraints() {
        var layout: String
        let views = [
            "popular": popularButton,
            "upcoming": upcomingButton,
            "editors": editorsButton
        ]
        let metrics = [
            "height": 44.0,
            "padding": 60.0,
            "spacing": 20.0
        ]
        
        layout = "H:|-[upcoming]-|"
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(layout, options: nil, metrics: metrics, views: views))
    
        layout = "V:|-(==padding)-[popular(==height)]-(==spacing)-[upcoming(==popular)]-(==spacing)-[editors(==upcoming)]"
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(layout, options: .AlignAllTrailing | .AlignAllLeading, metrics: metrics, views: views))
        
    }
    
    func setupButtons() {
        popularButton.setTitle("popular", forState: .Normal)
        popularButton.accessibilityIdentifier = "popular"
        popularButton.isAccessibilityElement = true
        popularButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        popularButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        popularButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        upcomingButton.setTitle("upcoming", forState: .Normal)
        upcomingButton.accessibilityIdentifier = "upcoming"
        upcomingButton.isAccessibilityElement = true
        upcomingButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        upcomingButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        upcomingButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        editorsButton.setTitle("editors", forState: .Normal)
        editorsButton.accessibilityIdentifier = "editors"
        editorsButton.isAccessibilityElement = true
        editorsButton.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        editorsButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        editorsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
}
