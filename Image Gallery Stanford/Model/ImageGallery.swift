//
//  ImageGallery.swift
//  Image Gallery Stanford
//
//  Created by aleksandre Khubuluri on 18.07.22.
//

import Foundation

struct ImageGallery: Codable
{
    let title: String?
    var galleryImages: [GalleryImage]?
    var uuid: String
    
    public var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(ImageGallery.self, from: json) {
            self = newValue
        } else {
            print("Decoding failed")
            return nil
        }
    }
    
    init(title: String?, galleryImages: [GalleryImage]?) {
        self.title = title
        self.galleryImages = galleryImages
        self.uuid = UUID().uuidString
    }
}
