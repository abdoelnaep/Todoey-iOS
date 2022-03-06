//
//  Category.swift
//  Todoey
//
//  Created by Abdullah on 05/03/2022.
//

import Foundation
import UIKit
import RealmSwift


class Category:Object {
//    @objc
    @objc  var name:String = ""
     let items = List<Item>()
     
    //let array = Array<Int>()
}
