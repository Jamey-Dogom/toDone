//
//  Item.swift
//  toDone
//
//  Created by Jamey Dogom on 8/27/19.
//  Copyright © 2019 Jamey Dogom. All rights reserved.
//

import Foundation

// to be able to encode itself into a plist or json Encodable, Decodable = Codable
class Item : Codable {

    var title : String = ""
    var done : Bool = false
    
    
}
