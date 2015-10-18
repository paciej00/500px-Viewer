//
//  PhotoListViewController.swift
//  AllegriaDi500px
//
//  Created by Paciej on 18/04/15.
//
//

import UIKit

/**
*  Ekran listy: Każydy element listy powinien zawierać zdjęcie, nazwę zdjęcia oraz jego ocenę (z pola rating z odpowiedzi z api). Lista powinna działać płynnie. Lista zdjęć powinna sama ładować kolejne elementy, kiedy użytkownik dojedzie do jej aktualnego końca. Jednorazowo powinno się ładować 20 elementów.

    Na ekranie o rozmiarze klasy Compact lista zdjęć powinna zajmować cały ekran urządzenia, a po kliknięciu na jej element powinny się pokazywać szczegóły zdjęcia, również pełnoekranowo.
    
    W przypadku rozmiaru klasy Regular lista powinna znajdować się po lewej stronie ekranu (mniej więcej 1/3 jego szerokości), a zdjęcia powinny się otwierać po prawej stronie (pozostałe 2/3) – tak jak w aplikacji Settings. Domyślnie (zanim użytkownik dokona jakiegokolwiek wyboru) powinno być wyświetlone pierwsze zdjęcie.
*/

/**
*  View controller used for showing items of a given feature downloaded from 500px API.
*/
//MARK: - PhotoListViewController
public class PhotoListViewController: BaseViewController {
   
    //MARK: - public properties
    public let feature: String
    public var photos = [Photo]()

    //MARK: - internal properties
    let cellReuseIdentifier = "PhotoListCellID"
    let photoListDownloader: PhotoListDownloader
    let photoDownloader: PhotoDownloader
    let tableView: UITableView
    var lastPage: Int {
        didSet {
            if lastPage == 1 && UIScreen.mainScreen().traitCollection.horizontalSizeClass == .Regular {
                tableView(tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
            }
        }
    }
    
    //MARK: - initialization
    public init(feature: String, photoListDownloader: PhotoListDownloader, photoDownloader: PhotoDownloader) {
        self.photoListDownloader = photoListDownloader
        self.photoDownloader = photoDownloader
        self.feature = feature
        tableView = UITableView(frame: CGRectZero)
        lastPage = 0
        super.init()
        
        self.photoListDownloader.photoListDownloaderDelegate = self
        self.photoDownloader.photoDownloaderDelegate = self
        title = feature
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.rowHeight = 100.0
        tableView.delegate = self
        tableView.dataSource = self
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    //MARK: - lifecycle
    public override func loadView() {
        super.loadView()
        view.addSubview(tableView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(PhotoCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        getNextPhotos()
    }
    
    /**
    When application receives memory warning photo images for invisible cells are removed from the memory and downloaders' cache are cleared.
    */
    public override func didReceiveMemoryWarning() {
        let visibleRows: [Int]? = (tableView.indexPathsForVisibleRows() as? [NSIndexPath])?.map{ (indexPath:NSIndexPath) -> Int in
            return indexPath.row
        }
        if let lower = visibleRows?.first, upper = visibleRows?.last {
            for photo in photos[0..<lower] {
                photo.clearData()
            }
            if upper+1 < photos.count {
                for photo in photos[upper..<photos.count] {
                    photo.clearData()
                }
            }
        }
        photoListDownloader.clearCachedData()
        photoDownloader.clearCachedData()
    }
    
    //MARK: - internal methods
    func getNextPhotos(){
        photoListDownloader.getPhotoList(feature, page: lastPage+1)
    }
    
    func getPhoto(url:String) {
        photoDownloader.getPhoto(fromURL: NSURL(string: url))
    }
    
    override func setupConstraints() {
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: nil, metrics: nil, views: ["tableView":tableView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: nil, metrics: nil, views: ["tableView":tableView]))
    }
    
}

//MARK: - UITableViewDelegate
extension PhotoListViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == photos.count - 1 {
            getNextPhotos()
        }
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath:  NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:  NSIndexPath) {
        if indexPath.row < photos.count {
            let photo = photos[indexPath.row]
            let vc = PhotoDetailsViewController(photo: photo, photoDownloader: PhotoDownloader(session: photoDownloader.session))
            self.splitViewController?.showDetailViewController(vc, sender: self)
        }
    }
    
}

//MARK: - UITableViewDataSource
extension PhotoListViewController: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath:  indexPath) as? PhotoCell
        let photo = photos[indexPath.row]
        
        cell?.nameLabel.text = photo.name
        cell?.ratingLabel.text = "\(photo.rating)"
        cell?.accessibilityIdentifier = "cell\(indexPath.row)"
        cell?.isAccessibilityElement = true
        
        if let data = photo.data {
            cell?.photoImageView.image = UIImage(data: data)
        } else {
            cell?.photoImageView.image = nil
            getPhoto(photo.imageURL)
        }
        
        return cell!
    }
    
}

//MARK: - PhotoListDownloaderDelegate
extension PhotoListViewController: PhotoListDownloaderDelegate {
    public func photoListDownloader(_: PhotoListDownloader, didDownloadPhotos photos: [Photo], fromPage page: Int) {
        self.photos += photos
        tableView.reloadData()
        lastPage = page
    }
    
    public func photoListDownloader(_: PhotoListDownloader, didFailToDownloadPhotos error: NSError?, fromPage page: Int?) {
        
    }
    
}

//MARK: - PhotoDownloaderDelegate
extension PhotoListViewController: PhotoDownloaderDelegate {
    
    /**
    Method is invoked by PhotoDownloader once it successfuly downloads photo image from a given URL. List of available Photos is filtered by this URL and then for every filtered photo its binary data is set. 
    
    Because downloading list of photos takes place in steps, it can happen that previously downloaded items occur on the newly downloaded list as well due to rating changes on the backened side, hence producing duplicates on the mobile side. To overcome this issue the downloaded binary data is set for every photo item with the same URL.
    
    Bottom line: duplicates in self.photos array can occur :)
    
    :param: _    instance of delegatee that sends the message
    :param: data binary data of downloaded photo
    :param: url  address from which the photo was downloaded
    */
    public func photoDownloader(_: PhotoDownloader, didDownloadPhoto data: NSData, fromURL url: String?) {
        let filteredPhotos = (photos.filter { (element) -> Bool in
            return element.imageURL == url!
        })
        for photo in filteredPhotos {
            photo.data = data
        }
        tableView.reloadData()
    }
    
    /**
    Method is invoked by PhotoDownloader when an error occurs while downloading the photo.
    
    :param: _     instance of delegatee that sends the message
    :param: error object describing error that occured during download operation
    :param: url   address from which the photo was tried to be downloaded
    */
    public func photoDownloader(_: PhotoDownloader, didFailToDownloadPhoto error: NSError, fromURL url: String?) {
        println(error.description)
    }
    
}
