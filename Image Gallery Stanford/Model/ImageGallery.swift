//
//  ImageGallery.swift
//  Image Gallery Stanford
//
//  Created by aleksandre Khubuluri on 18.07.22.
//

import Foundation

struct ImageGallery
{
    let title: String
    var galleryImages: [GalleryImage]?
    var uuid: String
    
    init(title: String, galleryImages: [GalleryImage]?) {
        self.title = title
        self.galleryImages = galleryImages
        self.uuid = UUID().uuidString
    }
}
