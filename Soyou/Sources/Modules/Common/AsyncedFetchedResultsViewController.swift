//
//  CommonViewControllers.swift
//  Soyou
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class AsyncedFetchedResultsViewController: UIViewController {
    
    var fetchLimit: Int = 0
    var fetchOffset: Int = 0
    var fetchBatchSize: Int = 0
    
    var fetchedResults: [AnyObject]?
    
    fileprivate var asyncFetchRequest: NSAsynchronousFetchRequest<NSFetchRequestResult>?
    fileprivate var asyncFetchResult: NSAsynchronousFetchResult<NSFetchRequestResult>?
    fileprivate var asyncFetchContext: NSManagedObjectContext = {
        var context: NSManagedObjectContext!
        MagicalRecord.save(blockAndWait: { (localContext) in
            context = localContext
        })
        return context
    }()
}

// MARK: Subclass methods
extension AsyncedFetchedResultsViewController {
    
    @objc func createFetchRequest(_ context: NSManagedObjectContext) -> NSFetchRequest<NSFetchRequestResult>? {
        assert(false)
        return nil
    }
    
    @objc func tableView() -> UITableView? {
        return nil
    }
    
    @objc func collectionView() -> UICollectionView? {
        return nil
    }
}

// MARK: Reqests
extension AsyncedFetchedResultsViewController {
    
    // Used to avoid appending the same result multiple times.
    func hasAppendedFetchedResultsForOffset(_ offset: Int) -> Bool {
        if let results = self.fetchedResults {
            return results.count > offset
        } else {
            return false
        }
    }
    
    func appendFetchedResults(_ results: [AnyObject]?) {
        // Get fetch results
        if let results = results {
            if let fetchedResults = self.fetchedResults {
                self.fetchedResults = fetchedResults + results
            } else {
                self.fetchedResults = results
            }
        }
    }
    
    func fetch(_ completion: ((Int, Int) -> Void)?) {
        // The offset for current fetch
        let offset = self.fetchOffset
        
        // Get fetch request
        guard let fetchRequest = self.createFetchRequest(self.asyncFetchContext) else { return }
        fetchRequest.fetchLimit = self.fetchLimit
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchBatchSize = self.fetchBatchSize
        
        // Stop last async fetch
        self.stopAndClearFetch()
        
        // Create asynchronous fetch request
        self.asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
            if !self.hasAppendedFetchedResultsForOffset(offset) {
                self.appendFetchedResults(result.finalResult)
                DispatchQueue.main.async {
                    // Reload UI
                    self.reloadUI()
                    // Completed
                    if let completion = completion { completion(offset, result.finalResult?.count ?? 0) }
                }
            }
        }
        
        // Do search
        self.asyncFetchContext.perform {
            if let asyncFetchRequest = self.asyncFetchRequest {
                do {
                    let result = try self.asyncFetchContext.execute(asyncFetchRequest)
                    if let result = result as? NSAsynchronousFetchResult<NSFetchRequestResult> {
                        self.asyncFetchResult = result
                    }
                } catch {
                    self.asyncFetchResult = nil
                    DLog(error)
                }
            }
        }
    }
    
    @objc func reloadData(_ completion: ((Int, Int) -> Void)?) {
        // Clear last fetch
        self.clearFetchResults()
        
        // Fetch offset
        self.fetchOffset = 0
        
        // Fetch
        self.fetch(completion)
    }
    
    @objc func reloadDataWithoutCompletion() {
        self.reloadData(nil)
    }
    
    @objc func loadMore(_ completion: ((Int, Int) -> Void)?) {
        // Fetch offset
        self.fetchOffset += self.fetchLimit
        
        // Fetch
        self.fetch(completion)
    }
}

// MARK: Routines
extension AsyncedFetchedResultsViewController {
    
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
