//
//  ImageCollectionCell.swift
//  Image Gallery Stanford
//
//  Created by aleksandre on 18.07.22.
//

import UIKit


class ImageCollectionCell: UICollectionViewCell
{
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var galleryImageView: UIImageView!
    
    public var imageURL: URL!
    

}
