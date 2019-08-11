//
//  BookClientOperations.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/11/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation

extension BookClient {
    
    func findBy(title: String, completion: @escaping (_ result: BookVolumeParser?, _ error: Error?) -> Void) {
        
        //get any random page
        
        let parameters = [
            BookParameterKeys.Format         : BookParameterValues.ResponseFormat
        ]
        
        _ = taskForGETMethod(parameters: parameters as [String : AnyObject]) { (data, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "Data retrieval failed"]
                completion(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
                return
            }
            do {
                let photosParser = try JSONDecoder().decode(BookVolumeParser.self, from: data )
                completion(photosParser, nil)
            } catch {
                print("\(#function) error: \(error)")
                completion(nil, error)
            }
        }
    }
    
    func getImage(imageUrl: String, result: @escaping (_ result: Data?, _ error: NSError?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            return
        }
        
        let task = taskForGETMethod(nil, url, parameters: [:]) { (data, error) in
            result(data, error)
            self.tasks.removeValue(forKey: imageUrl)
        }
        
        if tasks[imageUrl] == nil {
            tasks[imageUrl] = task
        }
    }
}

