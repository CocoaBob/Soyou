//
//  CommonViewControllers.swift
//  Soyou
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class SyncedFetchedResultsViewController: UIViewController {
    
    var fetchedResultsChangesInsert: [IndexPath]?
    var fetchedResultsChangesDelete: [IndexPath]?
    var fetchedResultsChangesUpdate: [IndexPath]?
    var fetchedResultsChangesMove: [(IndexPath,IndexPath)]?
    
    // MARK: NSFetchedResultsController
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    deinit {
        self.fetchedResultsController?.delegate = nil
    }
    
    // MARK: Routines
    func reloadData(_ completion: (() -> Void)?) {
        // Create NSFetchedResultsController
        self.fetchedResultsController = self.createFetchedResultsController()
        self.fetchedResultsController?.delegate = self
        // Do search
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            
        }
        // After searching
        DispatchQueue.main.async {
            // Reload table/collection view
            if let tableView = self.tableView() {
                tableView.reloadData()
            } else if let collectionView = self.collectionView() {
                collectionView.reloadData()
            }
            // Completed
            if let completion = completion { completion() }
        }
    }
    
    func reloadDataWithoutCompletion() {
        self.reloadData(nil)
    }
}

// MARK: Subclass methods
extension SyncedFetchedResultsViewController {
    
    // Should be overridden by sub-class
    func createFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
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
extension SyncedFetchedResultsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let tableView = self.tableView() {
            tableView.beginUpdates()
        } else if let _ = self.collectionView() {
            self.fetchedResultsChangesInsert = [IndexPath]()
            self.fetchedResultsChangesDelete = [IndexPath]()
            self.fetchedResultsChangesUpdate = [IndexPath]()
            self.fetchedResultsChangesMove = [(IndexPath,IndexPath)]()
        }
    }
    
    @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let tableView = self.tableView() {
            switch(type) {
            case .insert:
                if let newIndexPath = newIndexPath {
                    tableView.insertRows(at: [newIndexPath], with:.fade)
                }
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            case .move:
                if let indexPath = indexPath,
                    let newIndexPath = newIndexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                }
            case .update:
                if let indexPath = indexPath {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        } else if let _ = self.collectionView() {
            switch(type) {
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.fetchedResultsChangesInsert?.append(newIndexPath)
                }
            case .delete:
                if let indexPath = indexPath {
                    self.fetchedResultsChangesDelete?.append(indexPath)
                }
            case .move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    self.fetchedResultsChangesMove?.append((indexPath, newIndexPath))
                }
            case .update:
                if let indexPath = indexPath {
                    self.fetchedResultsChangesUpdate?.append(indexPath)
                }
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if let tableView = self.tableView() {
            switch(type) {
            case .insert:
                tableView.insertRows(at: [IndexPath(index: sectionIndex)], with: .fade)
            case .delete:
                tableView.deleteRows(at: [IndexPath(index: sectionIndex)], with: .fade)
            default:
                break
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let tableView = self.tableView() {
            tableView.endUpdates()
        } else if let collectionView = self.collectionView() {
            UIView.setAnimationsEnabled(false)
            collectionView.performBatchUpdates({ () -> Void in
                if let fetchedResultsChangesInsert = self.fetchedResultsChangesInsert {
                    collectionView.insertItems(at: fetchedResultsChangesInsert)
                }
                if let fetchedResultsChangesDelete = self.fetchedResultsChangesDelete {
                    collectionView.deleteItems(at: fetchedResultsChangesDelete)
                }
                if let fetchedResultsChangesUpdate = self.fetchedResultsChangesUpdate {
                    collectionView.reloadItems(at: fetchedResultsChangesUpdate)
                }
                if let fetchedResultsChangesMove = self.fetchedResultsChangesMove {
                    for (oldIndexPath, newIndexPath) in fetchedResultsChangesMove {
                        collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
                    }
                }
            }, completion: { (finished: Bool) -> Void in
                UIView.setAnimationsEnabled(true)
                self.fetchedResultsChangesInsert = nil
                self.fetchedResultsChangesDelete = nil
                self.fetchedResultsChangesUpdate = nil
                self.fetchedResultsChangesMove = nil
            })
        }
    }
}
