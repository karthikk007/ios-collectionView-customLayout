//
//  MylivnLayout.swift
//  Mylivn
//
//  Created by Karthik Kumar on 26/03/18.
//  Copyright © 2018 Karthik Kumar. All rights reserved.
//

import UIKit

// MARK: - MylivnLayoutDelegate protocol
protocol MylivnLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

// MARK: - MylivnLayout class
class MylivnLayout: UICollectionViewLayout {
    // MARK: - Members variables
    
    //1. MylivnLayoutDelegate Layout Delegate
    weak var delegate: MylivnLayoutDelegate!
    
    //2. Configurable properties
    fileprivate var numberOfColumns = 3
    fileprivate var cellPadding: CGFloat = 4
    
    //3. Array to keep a cache of attributes.
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    //4. Content height and size
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: - layout methods
    override func prepare() {
        // 1. Only calculate once
        
        cache.removeAll()
        contentHeight = 0
        
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var xOffsetTemp = xOffset
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        var flip = false
        
        // 3. Iterates through the list of items in the first section
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            let size = delegate.collectionView(collectionView, layout: self, sizeForItemAt: indexPath)
            
            let height = size.height
            
            let frame: CGRect
            if item < numberOfColumns {
               frame = CGRect(x: xOffsetTemp[column], y: yOffset[column], width: size.width, height: size.height)
            } else {
                if flip {
                    xOffset.reverse()
                    flip = false
                }
                frame = CGRect(x: xOffset[column], y: yOffset[column], width: size.width, height: size.height)
            }
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6. Updates the collection view content height
            contentHeight = max(contentHeight, frame.maxY)
            
            if item < numberOfColumns {
                
                yOffset[column] = yOffset[column] + height
                
                if column == numberOfColumns - 1 {
                    yOffset[column - 1] = yOffset[column]
                }
                
                if column < (numberOfColumns - 1) {
                    column += 1
                } else {
                    column = 0
                    flip = true
                }
                
                if item != 0, yOffset[numberOfColumns - 1] == 0 {
                    yOffset[numberOfColumns - 1] = yOffset[numberOfColumns - 2]
                }
                
                if xOffsetTemp[column] <= height {
                    xOffsetTemp[column] = height
                } else if xOffsetTemp[column] >= contentWidth {
                    xOffsetTemp[column] = contentWidth - height
                }
            } else {
                yOffset[column] = yOffset[column] + height
                
                if column < (numberOfColumns - 1) {
                    column += 1
                } else {
                    column = 0
                    flip = true
                }
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        
        attributes.alpha = 0.7
//        attributes.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForItem(at: itemIndexPath) {
            attributes.alpha = 0.7
            attributes.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            return attributes
        }
        
        return nil
    }
    
}

