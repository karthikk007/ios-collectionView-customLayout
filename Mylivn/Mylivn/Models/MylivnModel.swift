//
//  MylivnModel.swift
//  Mylivn
//
//  Created by Karthik Kumar on 27/03/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import Foundation

// MARK: - MylivnModel model
struct MylivnModel: Codable {
    
    // MARK: - member variables
    fileprivate var items: [ImageData]
    
    // save data on to archivePath
    static let archivePath = Bundle.main.bundlePath + "/MylivinArchive.json"
    
    // initial content or fallback content if archivePath doesnt exist
    static let recoverURL = Bundle.main.path(forResource: "Mylivin", ofType: "json")
    
    // MARK: - helper methods
    func count() -> Int {
        return items.count
    }
    
    func getImageData(for index: Int) -> ImageData? {
        if items.count > index, index >= 0 {
            return items[index]
        }
        
        return nil
    }
    
    mutating func swap(from: Int, to: Int) {
        if items.count > from, from >= 0, items.count > to, to >= 0 {
            items.insert(items.remove(at: from), at: to)
        }
    }
    
    func getImageData(for indexPath: IndexPath) -> ImageData? {
        if items.count > indexPath.row {
            return items[indexPath.row]
        }
        
        return nil
    }
    
    mutating func deleteItem(at indexPath: IndexPath) {
        if items.count > indexPath.row {
            items.remove(at: indexPath.row)
        }
    }
    
    mutating func addItem(url: URL) {
        let uuid = NSUUID().uuidString
        print("kk uuid = \(uuid)")
        items.insert(ImageData(uuid: uuid, imageUrlString: url.absoluteString), at: items.count)
    }
}

// MARK: - ImageData model
struct ImageData: Codable {
    let uuid: String
    let imageUrlString: String
    
}
