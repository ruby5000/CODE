//
//  Section.swift
//  TableView_ExpandableHeader_demo
//
//  Created by Galaxy on 22/11/17.
//  Copyright © 2017 Galaxy. All rights reserved.
//

import Foundation

struct Section {
    var category:String!
    var subcategory:[[String:String]]!
    var expanded:Bool!
    
    init(category:String,subcategory:[[String:String]],expanded:Bool) {
        self.category = category
        self.subcategory = subcategory
        self.expanded = expanded
    }
}
