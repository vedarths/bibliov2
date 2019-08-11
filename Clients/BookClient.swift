//
//  BookClient.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/11/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit

class BookClient  {
    
    var session = URLSession.shared
    var tasks: [String:URLSessionDataTask] = [:]
    
    class func sharedInstance() -> BookClient {
        struct Singleton {
            static var shared = BookClient()
        }
        return Singleton.shared
    }
    
    func taskForGETMethod(_ method: String? = nil, _ customUrl : URL? = nil, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        let request: NSMutableURLRequest!
        if let customUrl = customUrl {
            request = NSMutableURLRequest(url: customUrl)
        } else {
            request = NSMutableURLRequest(url: bookURL(parameters, withPathExtension: method))
        }
        showActivityIndicator(true)
        
        /* add standard headers */
        request.httpMethod = "GET"
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForGET(data, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        return task
    }
    
    /* create a URL from parameters */
    private func bookURL(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = BookClient.Constants.ApiScheme
        components.host = BookClient.Constants.ApiHost
        components.path = BookClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        if (!parameters.isEmpty) {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    private func showActivityIndicator(_ show: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = show
        }
    }
}
