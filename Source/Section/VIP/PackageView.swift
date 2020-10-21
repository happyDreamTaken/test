//
//  PackageView.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class PackageView: UIView {

    lazy var protocolButton = UIProtocolButton(frame: .zero)
    lazy var collectionLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        addSubview(collectionView)
        addSubview(protocolButton)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(170)
        }
        
        protocolButton.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(4)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(40)
        }
        
        protocolButton.setTitle(14, "点击查看", 0x999999, "《套餐及购买说明》", 0xfcaf25)
        protocolButton.protocolLabel.textAlignment = .center
        
        collectionLayout.itemSize = PackageCollectionViewCell.itemSize
        
        collectionLayout.minimumInteritemSpacing = 1
        collectionLayout.minimumLineSpacing = 1
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.sectionInset = UIEdgeInsets(top: 5, left: 13, bottom: 5, right: 5)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.register(PackageCollectionViewCell.self, forCellWithReuseIdentifier: PackageCollectionViewCell.identifier)
        collectionView.allowsSelection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
