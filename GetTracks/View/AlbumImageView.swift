//
//  AlbumImageView.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import UIKit

class AlbumImageView: UIImageView {
    
    var task: URLSessionTask!
    
    func loadImage(from url: URL) {
        
        image = nil
        
        if let task = task {
            task.cancel()
        }
        
        task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data, let newImage = UIImage(data: data) else {
                print("could not load image from URL : \(url)")
                return
            }
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}

