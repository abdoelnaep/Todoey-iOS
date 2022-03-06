//
//  Item.swift
//  Todoey
//
//  Created by Abdullah on 05/03/2022.
//

import Foundation
import RealmSwift
import UIKit

class Item:Object {
//    @objc
    @objc var title:String = ""
    @objc  var done:Bool = false
    @objc  var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
