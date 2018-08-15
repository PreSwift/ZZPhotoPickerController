//
//  ZZPhotoBrowserLivePhotoCollectionViewCell.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import PhotosUI

@available(iOS 9.1, *)
class ZZPhotoBrowserLivePhotoCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
 
    static let cellID = NSStringFromClass(ZZPhotoBrowserLivePhotoCollectionViewCell.self)
    
    var representedAssetIdentifier: String!
    private(set) var scrollView: UIScrollView!
    private(set) var imageView: UIImageView!
    private(set) var livePhotoView: PHLivePhotoView!
    private(set) lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        return indicator
    }()
    
    var isLivePhoto: Bool = false {
        didSet {
            if isLivePhoto {
                imageView.isHidden = true
                livePhotoView.isHidden = false
            } else {
                imageView.isHidden = false
                livePhotoView.isHidden = true
            }
        }
    }
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5.0
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
        
        livePhotoView = PHLivePhotoView()
        livePhotoView.contentMode = .scaleAspectFit
        scrollView.addSubview(livePhotoView)
        livePhotoView.snp.makeConstraints { (make) in
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
                let touchPoint = gesture.location(in: strongSelf.isLivePhoto ? strongSelf.livePhotoView : strongSelf.imageView)
                let newZoomScale = strongSelf.scrollView.maximumZoomScale
                let xSize = strongSelf.frame.width / newZoomScale
                let ySize = strongSelf.frame.height / newZoomScale
                strongSelf.scrollView.zoom(to: CGRect.init(x: touchPoint.x - xSize / 2, y: touchPoint.y - ySize / 2, width: xSize, height: ySize), animated: true)
            }
        }).disposed(by: disposeBag)
        
        scrollView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if isLivePhoto {
            return livePhotoView
        } else {
            return imageView
        }
    }
    
}
