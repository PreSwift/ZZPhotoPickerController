//
//  ZZPhotoBrowserCollectionViewFlowLayout.swift
//  Bylife_swift
//
//  Created by WES319 on 2017/11/6.
//  Copyright © 2017年 周远鸿. All rights reserved.
//

import UIKit

class ZZPhotoBrowserCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let itemSpacing: CGFloat = 20
    var offsetX: CGFloat = 0
    
    /// 一页宽度，算上空隙
    private lazy var pageWidth: CGFloat = {
        guard var pageWidth = self.collectionView?.bounds.width else {
            return 0
        }
        pageWidth += self.minimumLineSpacing
        return pageWidth
    }()
    
    /// 上次页码
    private lazy var lastPage: CGFloat = {
        guard let offsetX = self.collectionView?.contentOffset.x else {
            return 0
        }
        return round(offsetX / self.pageWidth)
    }()
    
    /// 最小页码
    private let minPage: CGFloat = 0
    
    /// 最大页码
    private lazy var maxPage: CGFloat = {
        guard var contentWidth = self.collectionView?.contentSize.width else {
            return 0
        }
        contentWidth += self.minimumLineSpacing
        return contentWidth / self.pageWidth - 1
    }()
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = itemSpacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        if offsetX != 0 {
            collectionView!.contentOffset = CGPoint.init(x: offsetX, y: collectionView!.contentOffset.y)
            offsetX = 0
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // 页码
        var page = round(proposedContentOffset.x / pageWidth)
        // 处理轻微滑动
        if velocity.x > 0.2 {
            page += 1
        } else if velocity.x < -0.2 {
            page -= 1
        }
        
        // 一次滑动不允许超过一页
        if page > lastPage + 1 {
            page = lastPage + 1
        } else if page < lastPage - 1 {
            page = lastPage - 1
        }
        if page > maxPage {
            page = maxPage
        } else if page < minPage {
            page = minPage
        }
        lastPage = page
        return CGPoint(x: page * pageWidth, y: 0)
    }
    
}
