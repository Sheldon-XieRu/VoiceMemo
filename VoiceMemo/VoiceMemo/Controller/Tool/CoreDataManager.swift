//
//  CoreDataManager.swift
//  VoiceMemo
//
//  Created by Ru on 16/11/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    static let shareInstance = CoreDataManager()
    private override init() {}
    
    var context:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    
    func insert(model: VoiceRecordModel){
        
        let entity = NSEntityDescription.entity(forEntityName: "VoiceRecord", in: context)
        let record = NSManagedObject(entity: entity!, insertInto: context)
        
        record.setValue(model.name, forKey: "name")
        
        
        do {
            try context.save()
            print("saved")
        }catch{
            print(error)
        }
    }
    
    
    func getRecords() -> [VoiceRecordModel]? {
        var records: [VoiceRecordModel] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VoiceRecord")
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            
            for result in searchResults as! [NSManagedObject] {
                let name = result.value(forKey: "name") as! String
                
                let model = VoiceRecordModel()
                model.name = name
                records.append(model)
            }
            
            return records
        } catch  {
            print(error)
            return nil
        }
        
    }

    
}

