//
//  HomeDataEntity+CoreDataProperties.swift
//  Basic UIKIT
//
//  Created by Amilzith on 17/07/24.
//
//

import Foundation
import CoreData


extension HomeDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HomeDataEntity> {
        return NSFetchRequest<HomeDataEntity>(entityName: "HomeDataEntity")
    }

    @NSManaged public var body: String?
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var userId: Int64

}

extension HomeDataEntity : Identifiable {

}
