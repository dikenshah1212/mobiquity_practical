//
//  LocationData+CoreDataProperties.swift
//  Demo_Code
//
//  Created by Diken Shah on 03/12/20.
//
//

import Foundation
import CoreData


extension LocationData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationData> {
        return NSFetchRequest<LocationData>(entityName: "LocationData")
    }

    @NSManaged public var title: String?
    @NSManaged public var lattitude: Double
    @NSManaged public var longitude: Double

}
