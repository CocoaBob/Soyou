//
//  CommonViewControllers.swift
//  Soyou
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class BaseViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsChangesInsert: [NSIndexPath]?
    var fetchedResultsChangesDelete: [NSIndexPath]?
    var fetchedResultsChangesUpdate: [NSIndexPath]?
    var fetchedResultsChangesMove: [(NSIndexPath,NSIndexPath)]?
    
    // MARK: NSFetchedResultsController
    let globalDispatchQueue = dispatch_queue_create(String(self.dynamicType) + "Queue", nil)
    var fetchedResultsControllerContext: NSManagedObjectContext?
    var fetchedResultsController : NSFetchedResultsController?
    
    deinit {
        self.fetchedResultsController?.delegate = nil
    }
    
    // Should be overridden by sub-class
    func createFetchedResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController? {
        assert(false)
        return nil
    }
    
    // MARK: UITableView or UICollectionView ?
    func tableView() -> UITableView? {
        return nil
    }
    
    func collectionView() -> UICollectionView? {
        return nil
    }
    
    // MARK: Routines
    
    func reloadData(completion: (() -> Void)?) {
        // Fetch in background then reload display in main thread
        dispatch_async(globalDispatchQueue) { () -> Void in
            // Context
            if self.fetchedResultsControllerContext == nil {
                self.fetchedResultsControllerContext = NSManagedObjectContext.MR_context()
                self.fetchedResultsControllerContext?.MR_observeContext(NSManagedObjectContext.MR_rootSavingContext())
            }
            // Re-create NSFetchedResultsController
            if let context = self.fetchedResultsControllerContext {
                self.fetchedResultsController = self.createFetchedResultsController(context)
                self.fetchedResultsController?.delegate = self
            }
            // Do search
            do {
                try self.fetchedResultsController?.performFetch()
            } catch {
                
            }
            // After searching
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let tableView = self.tableView() {
                    tableView.reloadData()
                } else if let collectionView = self.collectionView() {
                    collectionView.reloadData()
                }
                if let completion = completion { completion() }
            })
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    // As the NSFetchedResultsControllerContext is created in background thread
    // All the delegate methods will be called in the background thread
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let tableView = self.tableView() {
                tableView.beginUpdates()
            } else if let _ = self.collectionView() {
                self.fetchedResultsChangesInsert = [NSIndexPath]()
                self.fetchedResultsChangesDelete = [NSIndexPath]()
                self.fetchedResultsChangesUpdate = [NSIndexPath]()
                self.fetchedResultsChangesMove = [(NSIndexPath,NSIndexPath)]()
            }
        })
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let tableView = self.tableView() {
                switch(type) {
                case .Insert:
                    if let newIndexPath = newIndexPath {
                        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation:.Fade)
                    }
                case .Delete:
                    if let indexPath = indexPath {
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                case .Move:
                    if let indexPath = indexPath, let newIndexPath = newIndexPath {
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
                    }
                case .Update:
                    if let indexPath = indexPath {
                        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                }
            } else if let _ = self.collectionView() {
                switch(type) {
                case .Insert:
                    if let newIndexPath = newIndexPath {
                        self.fetchedResultsChangesInsert?.append(newIndexPath)
                    }
                case .Delete:
                    if let indexPath = indexPath {
                        self.fetchedResultsChangesDelete?.append(indexPath)
                    }
                case .Move:
                    if let indexPath = indexPath, newIndexPath = newIndexPath {
                        self.fetchedResultsChangesMove?.append((indexPath, newIndexPath))
                    }
                case .Update:
                    if let indexPath = indexPath {
                        self.fetchedResultsChangesUpdate?.append(indexPath)
                    }
                }
            }
        })
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let tableView = self.tableView() {
                switch(type) {
                case .Insert:
                    tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                case .Delete:
                    tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                default:
                    break
                }
            }
        })
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let tableView = self.tableView() {
                tableView.endUpdates()
            } else if let collectionView = self.collectionView() {
                collectionView.performBatchUpdates({ () -> Void in
                    if let fetchedResultsChangesInsert = self.fetchedResultsChangesInsert {
                        collectionView.insertItemsAtIndexPaths(fetchedResultsChangesInsert)
                    }
                    if let fetchedResultsChangesDelete = self.fetchedResultsChangesDelete {
                        collectionView.deleteItemsAtIndexPaths(fetchedResultsChangesDelete)
                    }
                    if let fetchedResultsChangesUpdate = self.fetchedResultsChangesUpdate {
                        collectionView.reloadItemsAtIndexPaths(fetchedResultsChangesUpdate)
                    }
                    if let fetchedResultsChangesMove = self.fetchedResultsChangesMove {
                        for (oldIndexPath, newIndexPath) in fetchedResultsChangesMove {
                            collectionView.moveItemAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
                        }
                    }
                    },
                    completion: { (finished: Bool) -> Void in
                        self.fetchedResultsChangesInsert = nil
                        self.fetchedResultsChangesDelete = nil
                        self.fetchedResultsChangesUpdate = nil
                        self.fetchedResultsChangesMove = nil
                })
            }
        })
    }
    
}