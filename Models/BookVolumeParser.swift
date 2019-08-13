//
//  BookVolumeParser.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/11/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation

struct BookVolumeParser: Codable {
    let kind: String?
    let totalItems: Int?
    let items: [BookItem]?
}

struct BookItem: Codable {
    let kind: String?
    let id: String
    let etag: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    let searchInfo: SearchInfo?
}

struct VolumeInfo: Codable {
    let title: String?
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let industryIdentifiers: [IndustryIdentifiers]?
    let pageCount : Int?
    let categories: [String]?
    let averageRating: Double?
    let ratingsCount: Int?
    let imageLinks: ImageLinks?
    let language: String?
    let previewLink: String?
    let infoLink: String?
    let canonicalVolumeLink: String?
}

struct SaleInfo: Codable {
    let country: String?
    let saleability: String?
    let isEbook: Bool?
}

struct SearchInfo: Codable {
    let textSnippet: String
}

struct IndustryIdentifiers: Codable {
    let type: String?
    let identifier: String?
}

struct ImageLinks : Codable {
    let smallThumbnail: String?
    let thumbnail : String?
}
