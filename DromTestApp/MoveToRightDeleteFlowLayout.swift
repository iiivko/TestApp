//
//  MoveToRightDeleteFlowLayout.swift
//  DromTestApp
//
//  Created by Владимир on 23.05.2022.
//

import UIKit

class MoveToRightDeleteFlowLayout: UICollectionViewFlowLayout {
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        //Detect and replace removed changes
        if let attributes = attributes, attributes.alpha == 0 {
            attributes.alpha = 1
            attributes.transform = attributes.transform.translatedBy(x: collectionViewContentSize.width, y: 0)
            return attributes
        }
        return attributes
    }
}
