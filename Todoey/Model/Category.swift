//
//  Category.swift
//  Todoey
//
//  Created by Brent Mifsud on 2019-02-02.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
