//
//  GridViewController.swift
//  Pods
//
//  Created by Tapani Saarinen on 04/09/15.
//
//

import UIKit

class GridViewController: UICollectionViewController {
    weak var browser: PhotoBrowser?
    var selectionMode = false
    var initialContentOffset = CGPointMake(0.0, CGFloat.max)
    
    private var marginP = CGFloat(0.0)
    private var gutterP = CGFloat(1.0)
    private var marginL = CGFloat(0.0)
    private var gutterL = CGFloat(1.0)
    private var columnsP = CGFloat(3.0)
    private var columnsL = CGFloat(4.0)
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        // For pixel perfection...
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
            // iPad
            columnsP = 6.0
            columnsL = 8.0
            marginP = 1.0
            gutterP = 2.0
            marginL = 1.0
            gutterL = 2.0
        }
        else
        if UIScreen.mainScreen().bounds.size.height == 480 {
            // iPhone 3.5 inch
            columnsP = 3.0
            columnsL = 4.0
            marginP = 0.0
            gutterP = 1.0
            marginL = 1.0
            gutterL = 2.0
        }
        else {
            // iPhone 4 inch
            columnsP = 3.0
            columnsL = 5.0
            marginP = 0.0
            gutterP = 1.0
            marginL = 0.0
            gutterL = 2.0
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cv = collectionView {
            cv.registerClass(GridCell.self, forCellWithReuseIdentifier: "GridCell")
            cv.alwaysBounceVertical = true
            cv.backgroundColor = UIColor.blackColor()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        // Cancel outstanding loading
        if let cv = collectionView {
            for cell in cv.visibleCells() {
                let c = cell as! GridCell
                
                if let p = c.photo {
                    p.cancelAnyLoading()
                }
            }
        }
        
        super.viewWillDisappear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        performLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func adjustOffsetsAsRequired() {
        // Move to previous content offset
        if initialContentOffset.y != CGFloat.max {
            collectionView!.contentOffset = initialContentOffset
            collectionView!.layoutIfNeeded() // Layout after content offset change
        }
        
        // Check if current item is visible and if not, make it so!
        if let b = browser {
            if b.numberOfPhotos > 0 {
                let currentPhotoIndexPath = NSIndexPath(forItem: b.currentIndex, inSection: 0)
                let visibleIndexPaths = collectionView!.indexPathsForVisibleItems()
                
                var currentVisible = false
                
                for indexPath in visibleIndexPaths {
                    if let path = indexPath as? NSIndexPath {
                        if path == currentPhotoIndexPath {
                            currentVisible = true
                            break
                        }
                    }
                }
                
                if !currentVisible {
                    collectionView!.scrollToItemAtIndexPath(currentPhotoIndexPath, atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
                }
            }
        }
    }

    private func performLayout() {
        if let navi = navigationController {
            let navBar = navi.navigationBar
            
            if let cv = collectionView {
                cv.contentInset = UIEdgeInsetsMake(navBar.frame.origin.y + navBar.frame.size.height + gutter, 0.0, 0.0, 0.0)
            }
        }
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if let cv = collectionView {
            cv.reloadData()
        }
        
        performLayout() // needed for iOS 5 & 6
    }

    //MARK: - Layout

    private var columns: CGFloat {
        if UIInterfaceOrientationIsPortrait(interfaceOrientation) {
            return columnsP
        }
        
        return columnsL
    }

    private var margin: CGFloat {
        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation) {
            return marginP
        }
    
        return marginL
    }

    private var gutter: CGFloat {
        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation) {
            return gutterP
        }
    
        return gutterL
    }

    //MARK: - Collection View

    override func collectionView(view: UICollectionView, numberOfItemsInSection section: Int) -> NSInteger {
        if let b = browser {
            return b.numberOfPhotos
        }
        
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GridCell", forIndexPath: indexPath) as! GridCell
        
        if let b = browser {
            if let photo = b.thumbPhotoAtIndex(indexPath.row) {
                cell.photo = photo
                cell.gridController = self
                cell.selectionMode = selectionMode
                cell.index = indexPath.row
                cell.selected = b.photoIsSelectedAtIndex(indexPath.row)
            
                if let img = b.imageForPhoto(photo) {
                    cell.displayImage()
                }
                else {
                    photo.loadUnderlyingImageAndNotify()
                }
            }
        }
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let b = browser {
            b.currentPhotoIndex = indexPath.row
            b.hideGrid()
        }
    }

    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let gridCell = cell as? GridCell {
            if let gcp = gridCell.photo {
                gcp.cancelAnyLoading()
            }
        }
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let value = CGFloat(floorf(Float((view.bounds.size.width - (columns - 1.0) * gutter - 2.0 * margin) / columns)))
        
        return CGSizeMake(value, value)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return gutter
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return gutter
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let margin = self.margin
        return UIEdgeInsetsMake(margin, margin, margin, margin)
    }
}
