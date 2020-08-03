//
//  TodoItems+CoreDataProperties.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 16.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//
//

import Foundation
import CoreData


extension TodoItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItems> {
        return NSFetchRequest<TodoItems>(entityName: "TodoItems")
    }

    @NSManaged public var text: String?

}
