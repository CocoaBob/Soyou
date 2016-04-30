//
//  CommonViewControllers.swift
//  Soyou
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class FetchedResultsViewController: UIViewController {
    
    var fetchLimit: Int = 0
    var fetchOffset: Int = 0
    var fetchBatchSize: Int = 0
    
    var fetchedResults: [AnyObject]?
    
    private var asyncFetchRequest: NSAsynchronousFetchRequest?
    private var asyncFetchResult: NSAsynchronousFetchResult?
    private var asyncFetchContext: NSManagedObjectContext = {
        var context: NSManagedObjectContext!
        MagicalRecord.saveWithBlockAndWait({ (localContext) in
            context = localContext
        })
        return context
    }()
}

// MARK: Subclass methods
extension FetchedResultsViewController {
    
    func createFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest? {
        assert(false)
        return nil
    }
    
    func tableView() -> UITableView? {
        return nil
    }
    
    func collectionView() -> UICollectionView? {
        return nil
    }
}

// MARK: Reqests
extension FetchedResultsViewController {
    
    func fetch(completion: ((Int) -> Void)?) {
        // Get fetch request
        guard let fetchRequest = self.createFetchRequest(self.asyncFetchContext) else { return }
        fetchRequest.fetchLimit = self.fetchLimit
        fetchRequest.fetchOffset = self.fetchOffset
        fetchRequest.fetchBatchSize = self.fetchBatchSize
        
        // Stop last async fetch
        self.stopAndClearFetch()
        
        // Create asynchronous fetch request
        self.asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Get fetch results
                if let finalResult = result.finalResult {
                    if let fetchedResults = self.fetchedResults {
                        self.fetchedResults = fetchedResults + finalResult
                    } else {
                        self.fetchedResults = finalResult
                    }
                }
                // Reload UI
                self.reloadUI()
                // Completed
                if let completion = completion { completion(result.finalResult?.count ?? 0) }
            })
        }
        
        // Do search
        self.asyncFetchContext.performBlock {
            if let asyncFetchRequest = self.asyncFetchRequest {
                do {
                    let result = try self.asyncFetchContext.executeRequest(asyncFetchRequest)
                    if let result = result as? NSAsynchronousFetchResult {
                        self.asyncFetchResult = result
                    }
                } catch {
                    self.asyncFetchResult = nil
                    DLog(error)
                }
            }
        }
    }
    
    func reloadData(completion: ((Int) -> Void)?) {
        // Clear last fetch
        self.clearFetchResults()
        
        // Fetch offset
        self.fetchOffset = 0
        
        // Fetch
        self.fetch(completion)
    }
    
    func reloadDataWithoutCompletion() {
        self.reloadData(nil)
    }
    
    func loadMore(completion: ((Int) -> Void)?) {
        // Fetch offset
        self.fetchOffset += self.fetchLimit
        
        // Fetch
        self.fetch(completion)
    }
}

// MARK: Routines
extension FetchedResultsViewController {
    
    // Reload table/collection view
    func reloadUI() {
        if let tableView = self.tableView() {
            tableView.reloadData()
        } else if let collectionView = self.collectionView() {
            collectionView.reloadData()
        }
    }
    
    // Clear fetch results
    func clearFetchResults() {
        self.fetchedResults = nil
        self.asyncFetchContext.reset()
    }
    
    // Stop & Clear last fetch
    func stopAndClearFetch() {
        self.asyncFetchResult?.progress?.cancel()
        self.asyncFetchResult = nil
        self.asyncFetchRequest = nil
    }
}
