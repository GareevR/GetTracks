//
//  TracklistAPI.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import Foundation

final class TracklistAPI {

    static let shared = TracklistAPI()
    
    // Fetch and decode JSON from iTunes for detail album view
    
    func fetchTracklist(completionHandler: @escaping ([Track]) -> Void, collectionId: Int) {
        
        let urlString = "https://itunes.apple.com/lookup?id=\(collectionId)&entity=song"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else {
                print("data was nil")
                return
            }
            guard var trackSummary = try? JSONDecoder().decode(Tracklist.self, from: data) else {
                print("could not decode JSON")
                return
            }
            trackSummary.results.removeFirst()
            completionHandler(trackSummary.results)
//            do {
//                let _ = try JSONDecoder().decode(Tracklist.self, from: data)
//            } catch {
//                print(error)
//            }
        }
        task.resume()
    }
}
