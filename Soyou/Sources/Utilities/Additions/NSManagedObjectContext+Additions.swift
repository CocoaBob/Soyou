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
            if let parent = ancestor.parentContext {
                ancestor = parent
            } else {
                break
            }
        }
        return ancestor
    }
    
    func saveWithBlockAndWait(block: ((NSManagedObjectContext)->())?) {
        let savingContext = self.ancestorContext()
        let localContext = NSManagedObjectContext.MR_contextWithParent(savingContext)
        localContext.performBlockAndWait { 
            localContext.MR_setWorkingName(#function)
            if let block = block {
                block(localContext)
            }
            localContext.MR_saveToPersistentStoreAndWait()
        }
    }
    
    func runBlockAndWait(block: ((NSManagedObjectContext)->())?) {
        let savingContext = self.ancestorContext()
        let localContext = NSManagedObjectContext.MR_contextWithParent(savingContext)
        localContext.performBlockAndWait {
            localContext.MR_setWorkingName(#function)
            if let block = block {
                block(localContext)
            }
        }
    }
}
