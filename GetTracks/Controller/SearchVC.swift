//
//  SearchVC.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import UIKit

class SearchVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let searchController = UISearchController()
    var albumList = [AlbumForView]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var history: [SearchHistory]?
    var writeToHistory = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Search"
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search albums"
        searchController.searchBar.delegate = self
        collectionView.backgroundColor = .systemGray6
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        setupCollectionView()
    
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       get {
          return .portrait
       }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDefaults = UserDefaults.standard
        if let key = userDefaults.string(forKey: "history") {
            writeToHistory = false
            searchController.searchBar.text = key
            searchBarSearchButtonClicked(self.searchController.searchBar)
            writeToHistory = true
            userDefaults.removeObject(forKey: "history")
        }
//        print("VIEW WILL APPEAR")
    }
    
    func setupCollectionView() {
        
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: "CV-cell")
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    // MARK: Cell itself
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CV-cell", for: indexPath)
        let album = albumList[indexPath.row]
        
        guard let albumCell = cell as? AlbumCell else {
            return cell
        }
        albumCell.titleLabel.text = album.name.maxLength(length: 10)
        if let url = URL(string: album.imageUrl) {
            albumCell.imageView.loadImage(from: url)
        }
        return cell
    }
    
    // MARK: Cell count equals search.count
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    // MARK: Cell Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(view.frame.width / 2 - 10)
        let height = CGFloat(width)
        
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumDetail = AlbumDetailVC(albumList[indexPath.row])
        present(albumDetail, animated: true)
    }
    
}

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: Option 1 - online results updating
    
    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else {
//            return
//        }
//        let anonymousFunction = {
//            (fetchedAlbumList: [Album]) in
//            DispatchQueue.main.async {
//                let albumForViewList = fetchedAlbumList.map({
//                    album in
//                    return AlbumForView(name: album.collectionName,
//                                        imageUrl: album.artworkUrl100.replacingOccurrences(of: "100x100bb", with: "500x500bb"),
//                                        id: album.collectionId, artist: album.artistName)
//                })
//                self.albumList = albumForViewList.sorted(by: {$0.name < $1.name})
//                self.collectionView.reloadData()
//            }
//        }
//        AlbumAPI.shared.fetchAlbums(completionHandler: anonymousFunction, searchText: text )
    }
        
    // MARK: Option 2 - update results after search button clicked
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        let anonymousFunction = {
            (fetchedAlbumList: [Album]) in
                let albumForViewList = fetchedAlbumList.map({
                    album in
                    return AlbumForView(name: album.collectionName,
                                        imageUrl: album.artworkUrl100.replacingOccurrences(of: "100x100bb", with: "500x500bb"),
                                        id: album.collectionId, artist: album.artistName)
                })
                self.albumList = albumForViewList
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
        }
        DispatchQueue.global(qos: .background).async {
            AlbumAPI.shared.fetchAlbums(completionHandler: anonymousFunction, searchText: text )
        }
        
        // Add to history database
        if writeToHistory {
            let newSearch = SearchHistory(context: self.context)
            newSearch.searchText = text
            do {
                try self.context.save()
            } catch {
                print("Unable to save data to Database")
            }
            fetchSearchHistory()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.albumList = []
            self.collectionView.reloadData()
        }
    }
}

// MARK: Core Data

extension SearchVC {
    
    private func fetchSearchHistory() {

        // Fetch the data from CoreData
        do {
            self.history = try context.fetch(SearchHistory.fetchRequest())
        } catch {
            print("Unable to fetch data from CoreData")
        }
    }
}
