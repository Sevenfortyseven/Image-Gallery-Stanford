//
//  UIImageView+.swift
//  Image Gallery Stanford
//
//  Created by aleksandre Khubuluri on 18.07.22.
//

import UIKit

extension UIImageView
{
    public func fetchImage(with url: URL?, start: ((Bool) -> Void)?, completion: @escaping ((Bool) -> Void)) {
        start?(true)
        self.image = nil
        guard let url = url else {
            print("Invalid URL")
            return
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, _, _ in
            if let data = data, let fetchedImage = UIImage(data: data) {
                self.image = fetchedImage
                completion(true)
            }
        }
        dataTask.resume()
    }
}
