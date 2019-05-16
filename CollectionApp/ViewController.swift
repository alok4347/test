//
//  ViewController.swift
//  CollectionApp
//
//  Created by Digivive Services Pvt Ltd on 08/05/19.
//  Copyright © 2019 Digivive Services Pvt Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    let cellIdentifier = "ItemCollectionViewCell"

     var numberOfSection = 2

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCollectionView()
        setupCollectionViewItemSize()
      
    }
    
    
    private func setupCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        mainCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupCollectionViewItemSize() {
        let customLayout = CustomLayout()
        customLayout.delegate = self
        mainCollectionView.collectionViewLayout = customLayout
    }


}



extension ViewController {
    
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 10
//    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ItemCollectionViewCell
        cell?.imageView.image = UIImage(named: "6.png")
        
        
        return cell!
        
    }
    
    
//   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
//
//    if section == 0 {
//        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height/3)
//    }else {
//        return CGSize(width: self.view.frame.size.width, height: 60.0)
//    }
//
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
//        return CGSize(width: 0.0, height: 0.0)
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if kind == UICollectionView.elementKindSectionHeader {
//
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"sectionHeader", for: indexPath) as? HeaderCell
//
//            headerView?.backgroundColor = UIColor.yellow
//            return headerView!
//        } else {
//           return UICollectionReusableView()
//        }
//
//    }

    
}



extension ViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/2, height: self.view.frame.size.width/2+50)
        
    }
}

