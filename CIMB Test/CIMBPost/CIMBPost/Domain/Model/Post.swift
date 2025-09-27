//
//  Post.swift
//  CIMBPost
//
//  Created by Phincon on 27/09/25.
//

import Foundation

struct Post: Identifiable, Decodable, Equatable, Hashable {
    let id: Int
    let title: String
    let body: String
}
