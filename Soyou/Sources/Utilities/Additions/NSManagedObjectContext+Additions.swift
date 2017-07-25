//
//  NSManagedObjectContext+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 01/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

extension NSManagedObjectContext {
    
    func ancestorContext() -> NSManagedObjectContext {
        var ancestor = self
        while true {
            if let parent = ancestor.parent {
                ancestor = parent
            } else {
                break
            }
        }
        return ancestor
    }
    
    func save(blockAndWait block: ((NSManagedObjectContext)->())?) {
        let savingContext = self.ancestorContext()
        let localContext = NSManagedObjectContext.mr_context(withParent: savingContext)
        localContext.performAndWait { 
            localContext.mr_setWorkingName(#function)
            if let block = block {
                block(localContext)
            }
            localContext.mr_saveToPersistentStoreAndWait()
        }
    }
    
    func runBlockAndWait(_ block: ((NSManagedObjectContext)->())?) {
        let savingContext = self.ancestorContext()
        let localContext = NSManagedObjectContext.mr_context(withParent: savingContext)
        localContext.performAndWait {
            localContext.mr_setWorkingName(#function)
            if let block = block {
                block(localContext)
            }
        }
    }
    
    func runBlock(_ block: ((NSManagedObjectContext)->())?) {
        let savingContext = self.ancestorContext()
        let localContext = NSManagedObjectContext.mr_context(withParent: savingContext)
        localContext.perform() {
            
            localContext.mr_setWorkingName(#function)
            if let block = block {
                block(localContext)
            }
        }
    }
}
