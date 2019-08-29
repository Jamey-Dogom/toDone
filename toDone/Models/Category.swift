//
//  Category.swift
//  toDone
//
//  Created by Jamey Dogom on 8/27/19.
//  Copyright © 2019 Jamey Dogom. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    // dynamic allows us to check for changes during run time
    @objc dynamic var name : String = ""
    // similar to models in Java Spring Boot
    // MANY to one
    let items = List<Item>()
}
