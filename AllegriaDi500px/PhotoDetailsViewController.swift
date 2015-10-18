//
//  PhotoDetailsViewController.swift
//  AllegriaDi500px
//
//  Created by Paciej on 18/04/15.
//
//

import UIKit

/**
*  Wyświetla zdjęcie przekazane z poprzedniego ekranu w widoku na pełny ekran z użyciem animacji "fade in" (przez krótki czas zmieniamy przeźroczystość widoku idąc od wartości 0 do wartości 1). Na zdjęciu w dolnej części ekranu wyświetlona jest nazwa i rating zdjęcia.
*/

/**
*  View controller used to display photo details and its image.
*/
//MARK: - PhotoDetailsViewController
public class PhotoDetailsViewController: BaseViewController {
    
    //MARK: - public properties
    public var photoDownloader: PhotoDownloader? {
        didSet {
            setPhotoDownloaderDelegate()
        }
    }
    public var photo: Photo? {
        didSet {
            setPhotoData()
            setImageFromPhoto()
        }
    }
    
    //MARK: - public properties
    public let imageView: UIImageView
    public let nameLabel: UILabel
    public let ratingLabel: UILabel

    //MARK: - initialization
    public init(photo: Photo?, photoDownloader: PhotoDownloader?) {
        imageView = UIImageView(frame: CGRectZero)
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityIdentifier = "image"
        imageView.isAccessibilityElement = true
        
        nameLabel = UILabel(frame: CGRectZero)
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        nameLabel.numberOfLines = 0
        nameLabel.backgroundColor = UIColor.whiteColor()
        nameLabel.textColor = UIColor.darkGrayColor()
        nameLabel.accessibilityIdentifier = "name"
        nameLabel.isAccessibilityElement = true
        
        ratingLabel = UILabel(frame: CGRectZero)
        ratingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        ratingLabel.numberOfLines = 1
        ratingLabel.backgroundColor = UIColor.whiteColor()
        ratingLabel.textColor = UIColor.darkGrayColor()
        ratingLabel.accessibilityIdentifier = "rating"
        ratingLabel.isAccessibilityElement = true
        
        self.photo = photo
        self.photoDownloader = photoDownloader
        
        super.init()
        setPhotoData()
        setPhotoDownloaderDelegate()
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    deinit {
        photoDownloader?.photoDownloaderDelegate = nil
    }
    
    //MARK: - lifecycle
    public override func loadView() {
        super.loadView()
        view.addSubview(imageView)
        view.addSubview(ratingLabel)
        view.addSubview(nameLabel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let photo = photo where photo.data == nil {
            photoDownloader?.getPhoto(fromURL: NSURL(string: photo.imageURL))
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setImageFromPhoto()
    }
    
    //MARK: - internal methods
    func setPhotoData() {
        if let photo = self.photo {
            ratingLabel.text = "\(photo.rating)"
            nameLabel.text = photo.name
            title = photo.name
        }
    }
    
    func setImageFromPhoto() {
        if let data = photo?.data {
            imageView.layer.opacity = 0.0
            imageView.image = UIImage(data: data)
            UIView.animateWithDuration(0.4, animations: { [unowned self] () -> Void in
                self.imageView.layer.opacity = 1.0
            })
        }
    }
    
    func setPhotoDownloaderDelegate() {
        photoDownloader?.photoDownloaderDelegate = self
    }
    
    override func setupConstraints() {
        let views =  [
            "imageView":imageView,
            "ratingLabel":ratingLabel,
            "nameLabel":nameLabel
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[nameLabel]|", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[nameLabel][ratingLabel]|", options: .AlignAllLeading | .AlignAllTrailing, metrics: nil, views: views))
    }
}

//MARK: - PhotoDownloaderDelegate
extension PhotoDetailsViewController: PhotoDownloaderDelegate {
    public func photoDownloader(_: PhotoDownloader, didDownloadPhoto data: NSData, fromURL url: String?) {
        photo?.data = data
        setImageFromPhoto()
    }
    
    public func photoDownloader(_: PhotoDownloader, didFailToDownloadPhoto error: NSError, fromURL url: String?) {
        println(error.description)
    }
}
