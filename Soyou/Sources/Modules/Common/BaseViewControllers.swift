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
    let fetchedResultsControllerQueue = dispatch_queue_create("FetchedResultsControllerQueue", DISPATCH_QUEUE_SERIAL)
    var fetchedResultsControllerContext: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController?
    private var fetchedResultsControllerForFetching: NSFetchedResultsController?
    
    deinit {
        self.fetchedResultsController?.delegate = nil
        self.fetchedResultsControllerContext?.MR_stopObservingContext(NSManagedObjectContext.MR_rootSavingContext())
    }
    
    // Should be overridden by sub-class
    func createFetchedResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController? {
        assert(false)
        return nil
    }
    
    // MARK: UITableView or UICollectionView ?
    
    // Should be overridden by sub-class
    func tableView() -> UITableView? {
        return nil
    }
    
    // Should be overridden by sub-class
    func collectionView() -> UICollectionView? {
        return nil
    }
    
    // MARK: Routines
    
    func reloadData(completion: (() -> Void)?) {
        // Fetch in background then reload display in main thread
        dispatch_async(fetchedResultsControllerQueue) { () -> Void in
            // Context
            if self.fetchedResultsControllerContext == nil {
                self.fetchedResultsControllerContext = NSManagedObjectContext.MR_context()
            }
            // Re-create NSFetchedResultsController
            if let context = self.fetchedResultsControllerContext {
                // Stop updating fetched results
                context.MR_stopObservingContext(NSManagedObjectContext.MR_rootSavingContext())
                self.fetchedResultsController?.delegate = nil
                // Create new FRC
                self.fetchedResultsControllerForFetching = self.createFetchedResultsController(context)
            }
            // Do search
            do {
                try self.fetchedResultsControllerForFetching?.performFetch()
            } catch {
                
            }
            
            // After searching
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.fetchedResultsController = self.fetchedResultsControllerForFetching
                // Start updating fetched results
                self.fetchedResultsController?.delegate = self
                self.fetchedResultsControllerContext?.MR_observeContext(NSManagedObjectContext.MR_rootSavingContext())
                // Reload table/collection view
                if let tableView = self.tableView() {
                    tableView.reloadData()
                } else if let collectionView = self.collectionView() {
                    collectionView.reloadData()
                }
                // Completed
                if let completion = completion { completion() }
            })
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    // As the NSFetchedResultsControllerContext is created in a background thread
    // All the delegate methods will be called in the background thread
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        let closure = { () -> () in
            if let tableView = self.tableView() {
                tableView.beginUpdates()
            } else if let _ = self.collectionView() {
                self.fetchedResultsChangesInsert = [NSIndexPath]()
                self.fetchedResultsChangesDelete = [NSIndexPath]()
                self.fetchedResultsChangesUpdate = [NSIndexPath]()
                self.fetchedResultsChangesMove = [(NSIndexPath,NSIndexPath)]()
            }
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            closure()
        })
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        let closure = { () -> () in
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
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            closure()
        })
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let closure = { () -> () in
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
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            closure()
        })
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        let closure = { () -> () in
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
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            closure()
        })
    }
}
