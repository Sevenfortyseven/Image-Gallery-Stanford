//
//  ImageDetails.swift
//  Image Gallery Stanford
//
//  Created by aleksandre on 18.07.22.
//

import UIKit

public class ImageDetailsViewController: UIViewController
{
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var scollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/15
            scrollView.maximumZoomScale = 1
            scrollView.delegate = self
        }
    }
    
    var imageData: GalleryImage?
    
}

extension ImageDetailsViewController: UIScrollViewDelegate
{
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scollViewWidth.constant   = scrollView.contentSize.width
    }
}
