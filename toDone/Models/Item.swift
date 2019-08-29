//
//  Item.swift
//  toDone
//
//  Created by Jamey Dogom on 8/27/19.
//  Copyright © 2019 Jamey Dogom. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    // ONE to many relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
