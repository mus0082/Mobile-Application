//
//  Locationhistory+CoreDataProperties.swift
//  Muhammad_Siddiqui_FE_8939717
//
//  Created by user229166 on 8/13/23.
//
//

import Foundation
import CoreData


extension Locationhistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locationhistory> {
        return NSFetchRequest<Locationhistory>(entityName: "Locationhistory")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var images: String?

}

extension Locationhistory : Identifiable {

}
