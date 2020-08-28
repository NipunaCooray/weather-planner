//
//  DataController.swift
//  weather
//
//  Created by Nipuna C on 27/8/20.
//  Copyright © 2020 Nipuna Cooray. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName:String){
        persistentContainer = NSPersistentContainer(name:modelName)
    }
    
    func load(completion:(()-> Void)? = nil){
        persistentContainer.loadPersistentStores{storeDescriotion, error in
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    
}
