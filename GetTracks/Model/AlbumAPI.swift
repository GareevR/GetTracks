//
//  AlbumAPI.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import Foundation

final class AlbumAPI {

    static let shared = AlbumAPI()
    
    // Fetch and decode JSON from iTunes for albums
    
    func fetchAlbums(completionHandler: @escaping ([Album]) -> Void, searchText: String) {
        
        let urlString = "https://itunes.apple.com/search?term=\(searchText)&entity=album&limit=200".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString!)!
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else {
                print("data was nil")
                return
            }
            
            guard let albumSummary = try? JSONDecoder().decode(AlbumList.self, from: data) else {
                print("could not decode JSON")
//                do {
//                    try JSONDecoder().decode(AlbumList.self, from: data)
//                } catch {
//                    print(error)
//                }
                return
            }
            completionHandler(albumSummary.results)
        }
        task.resume()
    }
}

