//
//  Item.swift
//  Todoey
//
//  Created by Brent Mifsud on 2018-12-10.
//  Copyright © 2018 Brent Mifsud. All rights reserved.
//

import Foundation

class Item {
    var title: String = ""
    var done: Bool = false
    
    init(Title: String, Done: Bool ) {
        self.title = Title
        self.done = Done
    }
}
