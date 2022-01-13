//
//  AlbumCell.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    let imageView = AlbumImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
//        self.backgroundColor = .systemMint
//        self.layer.cornerRadius = 10
        setupAlbumLabel()
        setupImageView()
    }
    
    func setupAlbumLabel() {
        
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        titleLabel.text
        titleLabel.textAlignment = .center
        
        titleLabel.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    func setupImageView() {
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
    
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension String {
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with: NSRange(location: 0, length: nsString.length > length ? length : nsString.length)) + ".."
        }
        return str
    }
}

