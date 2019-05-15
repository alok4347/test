
//

let sharedAppdelegate = (UIApplication.shared.delegate as! AppDelegate)
let IsIPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
let IsIPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
let extraTextSpaceForAssetCell : CGFloat = IsIPad ? 60.0 : 60.0




import UIKit
protocol AmbLayoutDelegate {
    // 1. Method to ask the delegate for the height of the image
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth:CGFloat) -> CGFloat
    // 2. Method to ask the delegate for the height of the annotation text
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    
}

class AmbLayoutAttributes:UICollectionViewLayoutAttributes {
    
    // 1. Custom attribute
    var photoHeight: CGFloat = 0.0
    
    // 2. Override copyWithZone to conform to NSCopying protocol
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! AmbLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    // 3. Override isEqual
    override func isEqual(_ object: Any?) -> Bool {
        if let attributtes = object as? AmbLayoutAttributes {
            if( attributtes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

var isIphone6OR_later :Bool {
    if IsIPad == true {
        return true
    }else{
        return true
    }
}
class AmbLayout: UICollectionViewLayout {
    //1. Amb Layout Delegate
    var delegate:AmbLayoutDelegate!
    var isHeaderEnabled = false
    //2. Configurable properties
    var numberOfColumns = isIphone6OR_later ? 2 : 1
    var cellPadding: CGFloat = 0.0
    
    //3. Array to keep a cache of attributes.
    fileprivate var cache = [AmbLayoutAttributes]()
    
    //4. Content height and size
    fileprivate var contentHeight:CGFloat  = 0.0
    fileprivate var isFooterHidden = false
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override class var layoutAttributesClass : AnyClass {
        return AmbLayoutAttributes.self
    }
    
    func prepareLayoutCustom() {
        // 1. Only calculate once
        
        
        
        
        if !isFooterHidden {
            contentHeight = 0
            cache .removeAll()
        }
        
        //if cache.count == 1  {
        contentHeight = 0
        
        cache .removeAll()
        //}
        
        if cache.isEmpty {
            
            // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            // 3. Iterates through the list of items in the first section
            
            var totalNumberOfItems = 0
            
            if isHeaderEnabled == false {
                for item in 0 ..< collectionView!.numberOfItems(inSection: 0)+1 {
                    
                    let indexPath = IndexPath(item: item, section: 0)
                    
                    // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
                    if indexPath.item == collectionView!.numberOfItems(inSection: 0) {
                        let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: 0)
                        if annotationHeight == -1 {
                            
                            //isFooterHidden = true
                        }else{
                            //isFooterHidden = false
                            
                            let attributes = AmbLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
                            attributes.photoHeight = 40;
                            let frame = CGRect(x: 0, y: contentHeight, width: (sharedAppdelegate.window?.bounds.width)!, height: 30)
                            attributes.frame = frame
                            attributes.zIndex = -10;
                            //print(attributes)
                            
                            if collectionView!.numberOfItems(inSection: 0) > 0 {
                                cache.append(attributes)
                                
                            }
                        }
                        
                    }else{
                        let width = columnWidth - cellPadding*2
                        let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath , withWidth:width)
                        let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                        let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                        let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                        
                        // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                        let attributes = AmbLayoutAttributes(forCellWith: indexPath)
                        attributes.photoHeight = photoHeight
                        attributes.frame = insetFrame
                        // print(attributes)
                        
                        cache.append(attributes)
                        
                        // 6. Updates the collection view content height
                        contentHeight = max(contentHeight, frame.maxY)
                        yOffset[column] = yOffset[column] + height
                        
                        column = column >= (numberOfColumns - 1) ? 0 : column+1
                    }
                    
                }
                
            }
                
            else{
                contentHeight = 0
                
                totalNumberOfItems = collectionView!.numberOfItems(inSection: 0)+1 // footer + header
                let indexPath = IndexPath(item: 0, section: 0)
                if collectionView!.numberOfItems(inSection: 0) > 0 {
                    let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: 0)
                    
                    if annotationHeight != -1  {
                        if indexPath.item == 0 {
                            let attributes = AmbLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
                            attributes.photoHeight = ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110;
                            let frame = CGRect(x: 0, y: contentHeight, width: (sharedAppdelegate.window?.bounds.width)!, height: ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110)
                            attributes.frame = frame
                            attributes.zIndex = -10;
                            //print(attributes)
                            cache.append(attributes)
                            contentHeight = max(contentHeight, frame.maxY)
                            yOffset[column] = yOffset[column] + ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110
                            
                            column = column >= (numberOfColumns - 1) ? 0 : column+1
                            column = 0
                            if numberOfColumns == 2 {
                                yOffset[1] = ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110
                            }
                            
                            
                        }
                    }else{
                        
                        let attributes = AmbLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
                        attributes.photoHeight = ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110;
                        let frame = CGRect(x: 0, y: contentHeight, width: (sharedAppdelegate.window?.bounds.width)!, height: ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110)
                        attributes.frame = frame
                        attributes.zIndex = -10;
                        //print(attributes)
                        cache.append(attributes)
                        contentHeight = max(contentHeight, frame.maxY)
                        yOffset[column] = yOffset[column] + ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110
                        
                        column = column >= (numberOfColumns - 1) ? 0 : column+1
                        column = 0
                        if numberOfColumns == 2 {
                            
                            yOffset[1] = ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110
                        }
                        contentHeight = contentHeight - ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110
                    }
                }
                
                
                for item in 0 ..< collectionView!.numberOfItems(inSection: 0)+1 {
                    
                    let indexPath = IndexPath(item: item, section: 0)
                    
                    // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
                    
                    if totalNumberOfItems == 1 {
                        return
                    }
                    
                    if indexPath.item == collectionView!.numberOfItems(inSection: 0) {
                        let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: 0)
                        if annotationHeight == -1 {
                            
                            //isFooterHidden = true
                        }else{
                            //isFooterHidden = false
                            
                            let attributes = AmbLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
                            attributes.photoHeight = 40;
                            let frame = CGRect(x: 0, y: contentHeight, width: (sharedAppdelegate.window?.bounds.width)!, height: 30)
                            attributes.frame = frame
                            attributes.zIndex = -10;
                            //print(attributes)
                            if collectionView!.numberOfItems(inSection: 0) > 0 {
                                cache.append(attributes)
                                
                            }                        }
                        
                    }else{
                        
                        let width = columnWidth - cellPadding*2
                        let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath , withWidth:width)
                        let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                        let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                        let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                        
                        // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                        let attributes = AmbLayoutAttributes(forCellWith: indexPath)
                        attributes.photoHeight = photoHeight
                        attributes.frame = insetFrame
                        // print(attributes)
                        
                        cache.append(attributes)
                        
                        // 6. Updates the collection view content height
                        contentHeight = max(contentHeight, frame.maxY)
                        yOffset[column] = yOffset[column] + height
                        
                        column = column >= (numberOfColumns - 1) ? 0 : column+1
                    }
                    
                    /*
                     
                     
                     */
                    
                    
                }
            }
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section == 0) {
            return CGSize(width: collectionView.bounds.width, height: 250)
            
        }
        return CGSize(width: collectionView.bounds.width, height: 60)
        
    }
    
    override var collectionViewContentSize : CGSize {
        
        if isFooterHidden {
            return CGSize(width: contentWidth, height: contentHeight)
        }
        return CGSize(width: contentWidth, height: contentHeight+30)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        // self.prepareLayout()
        
        let indexPathFooter = IndexPath(item: 0, section: 0)
        
        // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
        
        let annotationHeight1 = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPathFooter, withWidth: 0)
        if annotationHeight1 == -1 {
            
            isFooterHidden = true
        }else{
            isFooterHidden = false
        }
        
        self.prepareLayoutCustom()
        
        for attributes  in cache {
            if attributes.frame.intersects(rect ) {
                if attributes.representedElementKind == UICollectionView.elementKindSectionFooter {
                    // print("print a footer")
                }
                layoutAttributes.append(attributes)
            }
        }
        
        
        
        return layoutAttributes
    }
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}



