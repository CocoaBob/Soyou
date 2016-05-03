//
//  CommonViewControllers.swift
//  Soyou
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class FetchedResultsViewController: UIViewController {
    
    var fetchedResultsChangesInsert: [NSIndexPath]?
    var fetchedResultsChangesDelete: [NSIndexPath]?
    var fetchedResultsChangesUpdate: [NSIndexPath]?
    var fetchedResultsChangesMove: [(NSIndexPath,NSIndexPath)]?
    
    // MARK: NSFetchedResultsController
    var fetchedResultsController: NSFetchedResultsController?
    
    deinit {
        self.fetchedResultsController?.delegate = nil
    }
    
    // MARK: Routines
    func reloadData(completion: (() -> Void)?) {
        // Create NSFetchedResultsController
        self.fetchedResultsController = self.createFetchedResultsController()
        self.fetchedResultsController?.delegate = self
        // Do search
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            
        }
        // After searching
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
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

// MARK: Subclass methods
extension FetchedResultsViewController {
    
    // Should be overridden by sub-class
    func createFetchedResultsController() -> NSFetchedResultsController? {
        assert(false)
        return nil
    }
    
    // Should be overridden by sub-class
    func tableView() -> UITableView? {
        return nil
    }
    
    // Should be overridden by sub-class
    func collectionView() -> UICollectionView? {
        return nil
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension FetchedResultsViewController: NSFetchedResultsControllerDelegate {
    
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
                    if let indexPath = indexPath,
                        newIndexPath = newIndexPath {
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
