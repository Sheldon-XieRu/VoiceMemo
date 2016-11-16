//
//  VoiceRecord+CoreDataProperties.swift
//  VoiceMemo
//
//  Created by Ru on 16/11/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

import Foundation
import CoreData


extension VoiceRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VoiceRecord> {
        return NSFetchRequest<VoiceRecord>(entityName: "VoiceRecord");
    }

    @NSManaged public var name: String?

}
