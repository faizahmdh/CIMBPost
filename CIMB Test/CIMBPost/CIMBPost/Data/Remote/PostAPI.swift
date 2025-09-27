//
//  PostAPI.swift
//  CIMBPost
//
//  Created by Phincon on 27/09/25.
//

import Foundation


enum PostAPI {
    case list
    
    var request: URLRequest {
        switch self {
        case .list:
            let components = URLComponents(string: "https://jsonplaceholder.typicode.com/posts")!
            
            var req = URLRequest(url: components.url!)
            req.httpMethod = "GET"
            req.timeoutInterval = 30
            return req
        }
    }
}
