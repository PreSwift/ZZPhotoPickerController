//
//  ZZPhotoBrowserCollectionViewCell.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ZZPhotoBrowserCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
 
    static let cellID = NSStringFromClass(ZZPhotoBrowserCollectionViewCell.self)
    
    private(set) var scrollView: UIScrollView!
    private(set) var imageView: UIImageView!
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 10.0
        scrollView.delegate = self
        contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalTo(frame.size)
        }
        
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        doubleTap.rx.event.subscribe(onNext: { [weak self] (gesture) in
            guard let strongSelf = self else { return }
            if strongSelf.scrollView.zoomScale > 1 {
                strongSelf.scrollView.setZoomScale(1, animated: true)
            } else {
                let touchPoint = gesture.location(in: strongSelf.imageView)
                let newZoomScale = strongSelf.scrollView.maximumZoomScale
                let xSize = strongSelf.frame.width / newZoomScale
                let ySize = strongSelf.frame.height / newZoomScale
                strongSelf.scrollView.zoom(to: CGRect.init(x: touchPoint.x - xSize / 2, y: touchPoint.y - ySize / 2, width: xSize, height: ySize), animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}