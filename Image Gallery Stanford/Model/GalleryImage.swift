//
//  GalleryImage.swift
//  Image Gallery Stanford
//
//  Created by aleksandre Khubuluri on 18.07.22.
//

import UIKit

struct GalleryImage
{
    var aspectRatio: CGFloat?
    var url: URL?
    
    init(aspectRatio: CGFloat? = nil, url: URL? = nil) {
        self.aspectRatio = aspectRatio
        self.url = url
    }
}
