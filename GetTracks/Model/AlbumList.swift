//
//  AlbumList.swift
//  GetTracks
//
//  Created by Ринат Гареев on 11.01.2022.
//

import Foundation

struct AlbumList: Codable {
    let resultCount: Int
    let results: [Album]
}

struct Album: Codable {
    let wrapperType: String
    let collectionType: String
    let artistId: Int
    let collectionId: Int
    let amgArtistId: Int?
    let artistName: String
    let collectionName: String
    let collectionCensoredName: String
    let artistViewURL: String?
    let collectionViewUrl: String
    let artworkUrl60: String
    let artworkUrl100: String
    let collectionPrice: Double?
    let collectionExplicitness: String
    let trackCount: Int
    let copyright: String?
    let country: String
    let currency: String
    let releaseDate: String
    let primaryGenreName: String
    let contentAdvisoryRating: String?
}
