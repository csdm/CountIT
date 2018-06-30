//
//  ChronoSession+CoreDataProperties.swift
//  CountIT
//
//  Created by Claudio S. Di Mauro on 29/05/18.
//  Copyright © 2018 Claudio S. Di Mauro. All rights reserved.
//
//

import Foundation
import CoreData


extension ChronoSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChronoSession> {
        return NSFetchRequest<ChronoSession>(entityName: "ChronoSession")
    }

    @NSManaged public var title: String?
    @NSManaged public var time: String?
    @NSManaged public var data: String?
    @NSManaged public var count: Int16

}
