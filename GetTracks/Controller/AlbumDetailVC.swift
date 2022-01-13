//
//  AlbumDetailVC.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import UIKit

class AlbumDetailVC: UIViewController {

    let albumInfoView = UIView()
    let separator = UIView()
    
    let imageView = AlbumImageView()
    let albumName = UILabel()
    let artistName = UILabel()
    let album: AlbumForView
    
    let backgroundColor: UIColor = .white
    let textColor: UIColor = .black
    
    let spinner = UIActivityIndicatorView(style: .medium)
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    
    var tracklist = [TrackForView]()
    
    init(_ album: AlbumForView) {
        
        self.album = album
        imageView.loadImage(from: URL(string: album.imageUrl)!)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        safeArea = view.safeAreaLayoutGuide
        view.backgroundColor = backgroundColor
        
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell-id")
        
        setupImageView()
        setupAlbumInfoView()
        setupTableView()
        setupAlbumTextInfo()
        
        let anonymousFunction = {
            (fetchedTracklist: [Track]) in
            DispatchQueue.global(qos: .background).async {
                let tracklistForView = fetchedTracklist.map{
                    track in
                    return TrackForView(name: track.trackName ?? "")
                }
                self.tracklist = tracklistForView
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.tableView.reloadData()
                }
            }
        }
        addSpinner()
        DispatchQueue.global(qos: .background).async {
            TracklistAPI.shared.fetchTracklist(completionHandler: anonymousFunction, collectionId: self.album.id)
        }
    }
    
    func addSpinner() {
        view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        spinner.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20).isActive = true
        
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
    
    func setupAlbumInfoView() {
        
        view.addSubview(albumInfoView)
        
        albumInfoView.backgroundColor = .systemIndigo
        
        albumInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        albumInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height / 2).isActive = true
        albumInfoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        albumInfoView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func setupImageView() {
        
        albumInfoView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: albumInfoView.topAnchor, constant: view.frame.height / 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: albumInfoView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.height / 3.5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 3.5).isActive = true
        
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        
    }

    func setupAlbumTextInfo() {
    
        albumName.text = album.name
        artistName.text = album.artist
        
        
        albumName.font = UIFont(name: "Helvetica-Bold", size: 20)
        
        albumInfoView.addSubview(albumName)
        albumInfoView.addSubview(artistName)
        
        albumName.textAlignment = .center
        artistName.textAlignment = .center
        
        albumName.translatesAutoresizingMaskIntoConstraints = false
        artistName.translatesAutoresizingMaskIntoConstraints = false

        albumName.bottomAnchor.constraint(equalTo: albumInfoView.bottomAnchor, constant: -view.frame.height / 17).isActive = true
        artistName.bottomAnchor.constraint(equalTo: albumInfoView.bottomAnchor, constant: -view.frame.height / 40).isActive = true
        
        albumName.centerXAnchor.constraint(equalTo: albumInfoView.centerXAnchor).isActive = true
        artistName.centerXAnchor.constraint(equalTo: albumInfoView.centerXAnchor).isActive = true
        
        albumName.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        artistName.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        albumName.textColor = backgroundColor
        artistName.textColor = backgroundColor
    }
    
    func setupTableView() {

        view.addSubview(tableView)
        
        tableView.backgroundColor = backgroundColor
        tableView.separatorColor = textColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: albumInfoView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension AlbumDetailVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracklist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell-id", for: indexPath)
        
        cell.backgroundColor = backgroundColor
        cell.textLabel?.text = tracklist[indexPath.row].name
        cell.textLabel?.textColor = textColor

        return cell
    }
}

