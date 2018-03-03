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
    private var deletedSections = Set<Int>()
    private var insertedSections = Set<Int>()
    
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
            completion?()
        }
    }
    
    @objc func reloadDataWithoutCompletion() {
        self.reloadData(nil)
    }
}

// MARK: Subclass methods
extension SyncedFetchedResultsViewController {
    
    // Should be overridden by sub-class
    @objc func createFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
        assert(false)
        return nil
    }
    
    // Should be overridden by sub-class
    @objc func tableView() -> UITableView? {
        return nil
    }
    
    // Should be overridden by sub-class
    @objc func collectionView() -> UICollectionView? {
        return nil
    }
    
    // Optional
    @objc func tableViewRowIsAnimated() -> Bool {
        return true
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension SyncedFetchedResultsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.deletedSections = Set<Int>()
        self.insertedSections = Set<Int>()
        if let tableView = self.tableView() {
            DispatchQueue.main.async {
                UIView.setAnimationsEnabled(self.tableViewRowIsAnimated());
                tableView.beginUpdates()
            }
        } else if let _ = self.collectionView() {
            self.fetchedResultsChangesInsert = [IndexPath]()
            self.fetchedResultsChangesDelete = [IndexPath]()
            self.fetchedResultsChangesUpdate = [IndexPath]()
            self.fetchedResultsChangesMove = [(IndexPath,IndexPath)]()
        }
    }
    
    @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let tableView = self.tableView() {
            DispatchQueue.main.async {
                switch(type) {
                case .update:
                    if let indexPath = indexPath, !self.deletedSections.contains(indexPath.section), !self.insertedSections.contains(indexPath.section) {
                        tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                case .insert:
                    if let newIndexPath = newIndexPath {
                        tableView.insertRows(at: [newIndexPath], with:.fade)
                    }
                case .delete:
                    if let indexPath = indexPath {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                case .move:
                    if let indexPath = indexPath, let newIndexPath = newIndexPath, indexPath != newIndexPath {
                        tableView.moveRow(at: indexPath, to: newIndexPath)
                    }
                }
            }
        } else if let _ = self.collectionView() {
            switch(type) {
            case .update:
                if let indexPath = indexPath, !self.deletedSections.contains(indexPath.section), !self.insertedSections.contains(indexPath.section) {
                    self.fetchedResultsChangesUpdate?.append(indexPath)
                }
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.fetchedResultsChangesInsert?.append(newIndexPath)
                }
            case .delete:
                if let indexPath = indexPath {
                    self.fetchedResultsChangesDelete?.append(indexPath)
                }
            case .move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath, indexPath != newIndexPath {
                    self.fetchedResultsChangesMove?.append((indexPath, newIndexPath))
                }
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:   self.deletedSections.insert(sectionIndex)
        case .insert:   self.insertedSections.insert(sectionIndex)
        default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.deletedSections.removeAll()
        self.insertedSections.removeAll()
        if let tableView = self.tableView() {
            DispatchQueue.main.async {
                tableView.endUpdates()
                UIView.setAnimationsEnabled(true);
            }
        } else if let collectionView = self.collectionView() {
            UIView.setAnimationsEnabled(false)
            collectionView.performBatchUpdates({ () -> Void in
                if let fetchedResultsChangesUpdate = self.fetchedResultsChangesUpdate, fetchedResultsChangesUpdate.count > 0 {
                    collectionView.reloadItems(at: fetchedResultsChangesUpdate)
                }
                // The indexes for Insert must be the final items
                if let fetchedResultsChangesInsert = self.fetchedResultsChangesInsert, fetchedResultsChangesInsert.count > 0 {
                    collectionView.insertItems(at: fetchedResultsChangesInsert)
                }
                // The indexes for Update/Delete must be the original items
                if let fetchedResultsChangesDelete = self.fetchedResultsChangesDelete, fetchedResultsChangesDelete.count > 0 {
                    collectionView.deleteItems(at: fetchedResultsChangesDelete)
                }
                if let fetchedResultsChangesMove = self.fetchedResultsChangesMove, fetchedResultsChangesMove.count > 0 {
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
