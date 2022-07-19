//
//  DataStore.swift
//  Image Gallery Stanford
//
//  Created by aleksandre Khubuluri on 18.07.22.
//

import UIKit

class DataStore
{
    public static var sharedDataStore = DataStore()
    
    private init() { }
    
    public var galleryStore: [ImageGallery] = []
    
    public var chosenGallery: ImageGallery?

    public var removedGalleryStore: [ImageGallery] = []
    
    public func createGallery(with title: String) {
        galleryStore.append(ImageGallery(title: title, galleryImages: []))
    }
    
    public func chooseGallery(with indexPath: IndexPath) {
        // Replace chosen galleryStore gallery with current gallery before choosing new gallery
        let chosenGalleryIndex = galleryStore.firstIndex(where: {$0.uuid == chosenGallery?.uuid})
        if chosenGallery != nil, chosenGalleryIndex != nil {
            galleryStore[chosenGalleryIndex!] = chosenGallery!
        }
    }
    
    public func removeImage(with indexPath: IndexPath) {
        chosenGallery?.galleryImages?.remove(at: indexPath.row)
    }
    
//    public func save(gallery: ImageGallery) {
//        if let json = gallery.json {
//            if let url = try? FileManager.default.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: true
//            ).appendingPathComponent("Untitled.json") {
//                do {
//                    try json.write(to: url)
//                    print("Saved successfully")
//                } catch let error {
//                    print("Couldn't save \(error)")
//                }
//            }
//        }
//    }
//
//    public func load() {
//        if let url = try? FileManager.default.url(
//            for: .documentDirectory,
//            in: .userDomainMask,
//            appropriateFor: nil,
//            create: true
//        ).appendingPathComponent("Untitled.json") {
//            if let jsonData = try? Data(contentsOf: url) {
//                if let savedGallery = ImageGallery(json: jsonData) {
//                    galleryStore.append(savedGallery)
//                }
//            }
//        }
//    }
//
    
    
    
    
}
