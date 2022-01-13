//
//  AlbumImageView.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class AlbumImageView: UIImageView {
    
    var task: URLSessionTask!
    let spinner = UIActivityIndicatorView(style: .large)
    
    func loadImage(from url: URL) {
        
        image = nil
        addSpinner()
        
        DispatchQueue.global(qos: .background).async {
            if let task = self.task {
                task.cancel()
            }
            
            if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
                DispatchQueue.main.async {
                    self.image = imageFromCache
                    self.removeSpinner()
                }
                return
            }
            
            self.task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                guard let data = data, let newImage = UIImage(data: data) else {
                    print("could not load image from URL : \(url)")
                    return
                }
                imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.image = newImage
                    self.removeSpinner()
                }
            }
            self.task.resume()
        }
    }
    
    func addSpinner() {
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
}

