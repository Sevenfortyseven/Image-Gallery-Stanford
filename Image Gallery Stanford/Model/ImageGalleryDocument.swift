//
//  ImageGalleryDocument.swift
//  Image Gallery Stanford
//
//  Created by aleksandre Khubuluri on 18.07.22.
//

import UIKit

class ImageGalleryDocument: UIDocument {
    
    private var galleryStore = DataStore.sharedDataStore
    
    override func contents(forType typeName: String) throws -> Any {
        
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
    }
}

