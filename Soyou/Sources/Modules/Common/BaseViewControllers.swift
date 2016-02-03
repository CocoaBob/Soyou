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
    
    private var _fetchedResultsController : NSFetchedResultsController? = nil
    
    // Should be overridden by sub-class
    func createFetchedResultsController() -> NSFetchedResultsController? {
        assert(false);
        return nil
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        get {
            if _fetchedResultsController == nil {
                _fetchedResultsController = createFetchedResultsController()
                if let controller = _fetchedResultsController {
                    controller.delegate = self
                }
            }
            return _fetchedResultsController!
        }
    }
    
    // MARK: UITableView or UICollectionView ?
    func tableView() -> UITableView? {
        return nil
    }
    
    func collectionView() -> UICollectionView? {
        return nil
    }
    
    // MARK: Routines
    
    func reloadData() {
        _fetchedResultsController = nil
        if let tableView = self.tableView() {
            tableView.reloadData()
        } else if let collectionView = self.collectionView() {
            collectionView.reloadData()
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        if let tableView = self.tableView() {
            tableView.beginUpdates()
        } else if let _ = self.collectionView() {
            fetchedResultsChangesInsert = [NSIndexPath]()
            fetchedResultsChangesDelete = [NSIndexPath]()
            fetchedResultsChangesUpdate = [NSIndexPath]()
            fetchedResultsChangesMove = [(NSIndexPath,NSIndexPath)]()
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
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
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade);
                }
            }
        } else if let _ = self.collectionView() {
            switch(type) {
            case .Insert:
                if let newIndexPath = newIndexPath {
                    fetchedResultsChangesInsert?.append(newIndexPath)
                }
            case .Delete:
                if let indexPath = indexPath {
                    fetchedResultsChangesDelete?.append(indexPath)
                }
            case .Move:
                if let indexPath = indexPath, newIndexPath = newIndexPath {
                    fetchedResultsChangesMove?.append((indexPath, newIndexPath))
                }
            case .Update:
                if let indexPath = indexPath {
                    fetchedResultsChangesUpdate?.append(indexPath)
                }
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
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
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if let tableView = self.tableView() {
            tableView.endUpdates()
        } else if let collectionView = self.collectionView() {
            collectionView.performBatchUpdates(
                { () -> Void in
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
                completion:
                { (finished: Bool) -> Void in
                    self.fetchedResultsChangesInsert = nil
                    self.fetchedResultsChangesDelete = nil
                    self.fetchedResultsChangesUpdate = nil
                    self.fetchedResultsChangesMove = nil
                }
            )
        }
    }
    
}

class BaseTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: NSFetchedResultsController

    private var _fetchedResultsController : NSFetchedResultsController? = nil
    
    // Should be overridden by sub-class
    func createFetchedResultsController() -> NSFetchedResultsController? {
        assert(false);
        return nil
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        get {
            if _fetchedResultsController == nil {
                _fetchedResultsController = createFetchedResultsController()
                if let controller = _fetchedResultsController {
                    controller.delegate = self
                }
            }
            return _fetchedResultsController!
        }
    }
    
    // MARK: Routines
    
    func reloadData() {
        _fetchedResultsController = nil
        self.tableView.reloadData()
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch(type) {
        case .Insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation:.Fade)
            }
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade);
            }
        case .Move:
            if let indexPath = indexPath, newIndexPath = newIndexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch(type) {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}
