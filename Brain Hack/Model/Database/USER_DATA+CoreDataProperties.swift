//
//  USER_DATA+CoreDataProperties.swift
//  
//
//  Created by Darshan on 30/07/23.
//
//

import Foundation
import CoreData


extension USER_DATA {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<USER_DATA> {
        return NSFetchRequest<USER_DATA>(entityName: "USER_DATA")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?

}
