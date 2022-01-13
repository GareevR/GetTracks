//
//  Tracklist.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import Foundation

struct Tracklist: Codable {
    let resultCount: Int
    var results: [Track]
}

struct Track: Codable {
    let wrapperType: String
    let collectionType: String?
    let artistID: Int?
    let collectionID: Int?
    let amgArtistID: Int?
    let artistName, collectionName, collectionCensoredName: String
    let artistViewURL: String?
    let collectionViewURL: String?
    let artworkUrl60, artworkUrl100: String
    let collectionPrice: Double?
    let collectionExplicitness: String
    let trackCount: Int
    let copyright: String?
    let country, currency: String
    let releaseDate: String
    let primaryGenreName: String
    let kind: String?
    let trackID: Int?
    let trackName, trackCensoredName: String?
    let trackViewURL: String?
    let previewURL: String?
    let artworkUrl30: String?
    let trackPrice: Double?
    let trackExplicitness: String?
    let discCount, discNumber, trackNumber, trackTimeMillis: Int?
    let isStreamable: Bool?
}
