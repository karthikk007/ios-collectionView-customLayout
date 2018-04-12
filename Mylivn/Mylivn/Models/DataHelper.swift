//
//  DataHelper.swift
//  Mylivn
//
//  Created by Karthik Kumar on 27/03/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

// MARK: - DataHelperDelegate protocol
protocol DataHelperDelegate: class {
    func dataLoaded()
}

// MARK: - CollectionViewDataSource protocol
protocol CollectionViewDataSource: class {
    func refresh()
    func howManyCells() -> Int
    func imageUrl(for indexPath: IndexPath) -> String
    func swap(fromIndexPath: IndexPath, toIndexPath: IndexPath)
    func getImageData(for indexPath: IndexPath) -> ImageData?
    func deleteItem(at indexPath: IndexPath)
    func addItem(url: URL)
    func save()
}

// MARK: - DataHelper class
class DataHelper {
    
    let delegate: DataHelperDelegate
    
    fileprivate var data: MylivnModel?
    
    init(delegate: DataHelperDelegate) {
        
        self.delegate = delegate
        
        loadData()

    }
    
    private func loadData() {
        // try to load archivePath
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: MylivnModel.archivePath), options: .mappedIfSafe)
            
            if let data = try? JSONDecoder().decode(MylivnModel.self, from: data) {
                self.data = data
            } else {
                self.data = nil
            }
            
            delegate.dataLoaded()
            
            return
        } catch {
            // handle error
        }
        
        // try to load content or fallback content if archivePath doesnt exist
        if let path = MylivnModel.recoverURL {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                if let data = try? JSONDecoder().decode(MylivnModel.self, from: data) {
                    self.data = data
                } else {
                    self.data = nil
                }
                
                delegate.dataLoaded()
                
                return
            } catch {
                // handle error
            }
        }
        
        // fall through
        data = nil
        delegate.dataLoaded()
    }
    
    private func saveModel() {
        
        let encoded = try? JSONEncoder().encode(self.data)
        
        do {
            try encoded?.write(to: URL(fileURLWithPath: MylivnModel.archivePath))
        } catch {
            
        }
    }
    
    private func refreshData() {
        loadData()
    }
}


// MARK: - CollectionViewDataSource implementation
extension DataHelper: CollectionViewDataSource {
    func howManyCells() -> Int {
        return data?.count() ?? 0
    }
    
    func imageUrl(for indexPath: IndexPath) -> String {
        return data?.getImageData(for: indexPath.row)?.imageUrlString ?? ""
    }
    
    func swap(fromIndexPath: IndexPath, toIndexPath: IndexPath) {
        data?.swap(from: fromIndexPath.row, to: toIndexPath.row)
    }
    
    func getImageData(for indexPath: IndexPath) -> ImageData? {
        return data?.getImageData(for: indexPath)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        data?.deleteItem(at: indexPath)
    }
    
    func addItem(url: URL) {
        data?.addItem(url: url)
    }
    
    func save() {
        saveModel()
    }
    
    func refresh() {
        refreshData()
    }
}
