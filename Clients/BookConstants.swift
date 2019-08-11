//
//  BookConstants.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/11/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation

extension BookClient {
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.googleapis.com"
        static let ApiPath = "/books/v1/volumes"
    }
    
    struct BookParameterKeys {
        static let Method = "method"
        static let Format = "format"
        static let APIKey = "api_key"
        static let QueryKey = "q"
    }
    
    struct BookParameterValues {
        static let APIKey = "73b2b0363ffb9110ebce27808e448e32"
        static let ResponseFormat = "json"
    }
}
