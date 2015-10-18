//
//  BaseViewController.swift
//  AllegriaDi500px
//
//  Created by Paciej on 26/04/15.
//
//

import UIKit

/**
*  Class setups features common for all view controllers used in the project.
*/
public class BaseViewController: UIViewController {
    
    //MARK: - initialization
    public init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    //MARK: - lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.accessibilityIdentifier = "back button"
        navigationItem.backBarButtonItem?.isAccessibilityElement = true
        edgesForExtendedLayout = UIRectEdge.None
        view.backgroundColor = UIColor.whiteColor()
        setupConstraints()
    }
    
    //MARK - public methods
    public override func valueForUndefinedKey(key: String) -> AnyObject? {
        return nil
    }
    
    //MARK: - internal methods
    /**
    Method is called in viewDidLoad and is intented for setup of NSLayoutConstraints for view controller's views. No need to call super when inheriting from BaseViewController.
    */
    func setupConstraints() {}
}
