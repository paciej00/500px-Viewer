//
//  PhotoCell.swift
//  AllegriaDi500px
//
//  Created by Paciej on 19/04/15.
//
//

import UIKit

/**
*  Cell for displaying photo item.
*/
//MARK: - PhotoCell
public class PhotoCell: UITableViewCell {
    
    //MARK: - internal properties
    let photoImageView = UIImageView(frame: CGRectZero)
    let nameLabel = UILabel(frame: CGRectZero)
    let ratingLabel = UILabel(frame: CGRectZero)
    
    //MARK: - initialization
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        photoImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        photoImageView.contentMode = .ScaleAspectFit
        photoImageView.accessibilityIdentifier = "photo cell image"
        photoImageView.isAccessibilityElement = true
        
        nameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        nameLabel.numberOfLines = 0
        nameLabel.accessibilityIdentifier = "photo cell name"
        nameLabel.isAccessibilityElement = true
        
        ratingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        ratingLabel.accessibilityIdentifier = "photo cell rating"
        ratingLabel.isAccessibilityElement = true
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        
        let views = [
            "photoImageView": photoImageView,
            "nameLabel": nameLabel,
            "ratingLabel": ratingLabel
        ]
        let metrics = [
            "photoImageViewWidht": 100.0,
            "ratingLabelHeight": 20.0,
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[photoImageView(==photoImageViewWidht@750,<=photoImageViewWidht@1000)]-[nameLabel]-|", options: nil, metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[photoImageView]|", options: nil, metrics: metrics, views: views))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[nameLabel]-[ratingLabel(==ratingLabelHeight)]-|", options: .AlignAllTrailing | .AlignAllLeading, metrics: metrics, views: views))
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
}
