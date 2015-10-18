//
//  AppDelegate.swift
//  AllegriaDi500px
//
//  Created by Paciej on 18/04/15.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - internal properties
    var window: UIWindow?
    
    var masterNavigationController: UINavigationController!
    var detailNavigationController: UINavigationController!
    var splitViewController: UISplitViewController!
    
    //MARK: - lifecycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let masterViewController = MainViewController()
        masterNavigationController = UINavigationController(rootViewController: masterViewController)
       
        let detailViewController = PhotoDetailsViewController(photo: nil, photoDownloader: nil)
        detailViewController.navigationItem.hidesBackButton = true
        detailNavigationController = UINavigationController(rootViewController: detailViewController)
        
        splitViewController = UISplitViewController()
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        splitViewController.preferredPrimaryColumnWidthFraction = 0.33
        splitViewController.preferredDisplayMode = .AllVisible
        splitViewController.delegate = self
        
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        return true
    }
}

//MARK: - UISplitViewControllerDelegate
extension AppDelegate: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        
        if let mainCtrl = masterNavigationController.topViewController as? MainViewController {
            //Do not collapse anything onto primaryViewController if MainViewController is presented as primaryViewController
            return true
        } else if let photoDetailsCtrl = detailNavigationController.topViewController as? PhotoDetailsViewController, photo = photoDetailsCtrl.photo {
            //Collapse photoDetailsCtrl onto primaryViewController if PhotoDetailsViewController with photo is presented as secondaryViewController
            photoDetailsCtrl.navigationItem.hidesBackButton = false
            detailNavigationController.popToRootViewControllerAnimated(false)
            masterNavigationController.showViewController(photoDetailsCtrl, sender: self)
        }
        return true
    }
    
    func splitViewController(splitViewController: UISplitViewController, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController!) -> UIViewController? {
        if let mainCtrl = masterNavigationController.topViewController as? MainViewController {
            //Do not separete anything from primaryViewController if MainViewController is presented as primaryViewController
            return nil
        } else if let photoDetailsCtrl = masterNavigationController.topViewController as? PhotoDetailsViewController {
            //Separete photoDetailsCtrl from primaryViewController if PhotoDetailsViewController is presented as primaryViewController
            photoDetailsCtrl.navigationItem.hidesBackButton = true
            masterNavigationController.popViewControllerAnimated(false)
            detailNavigationController.pushViewController(photoDetailsCtrl, animated: false)
            return detailNavigationController
        } else if let photoListCtrl = masterNavigationController.topViewController as? PhotoListViewController {
            //Present PhotoDetailsViewController with first photo on the list
            photoListCtrl.tableView(photoListCtrl.tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            return detailNavigationController
        }
        return nil
    }
    
    func splitViewController(splitViewController: UISplitViewController, showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
        if splitViewController.collapsed {
            vc.navigationItem.setHidesBackButton(false, animated: true)
            masterNavigationController.showViewController(vc, sender: self)
        } else {
            vc.navigationItem.setHidesBackButton(true, animated: false)
            detailNavigationController.popToRootViewControllerAnimated(false)
            detailNavigationController.pushViewController(vc, animated: false)
        }
        return true
    }
    
}

