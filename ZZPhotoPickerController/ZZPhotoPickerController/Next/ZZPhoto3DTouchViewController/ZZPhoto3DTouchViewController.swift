//
//  ZZPhoto3DTouchViewController.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 15/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import PhotosUI

class ZZPhoto3DTouchViewController: UIViewController {

    private(set) lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        return indicator
    }()
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    @available(iOS 9.1, *)
    fileprivate lazy var livePhotoView: PHLivePhotoView = {
        let livePhotoView = PHLivePhotoView()
        return livePhotoView
    }()
    
    let asset: PHAsset
    
    required init(asset: PHAsset) {
        self.asset = asset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        if #available(iOS 9.1, *) {
            if asset.mediaSubtypes.contains(.photoLive) {
                
                view.addSubview(livePhotoView)
                livePhotoView.snp.makeConstraints({ (make) in
                    if #available(iOS 11.0, *) {
                        make.edges.equalTo(view.safeAreaLayoutGuide)
                    } else {
                        make.edges.equalToSuperview()
                    }
                })
                
                let options = PHLivePhotoRequestOptions()
                options.isNetworkAccessAllowed = true
                options.progressHandler = { (progress, error, stop, info) in
                    DispatchQueue.main.async {
                        if progress < 1 {
                            if self.indicator.isAnimating == false {
                                self.indicator.startAnimating()
                            }
                        } else {
                            self.indicator.stopAnimating()
                        }
                    }
                }
                PHImageManager.default().requestLivePhoto(for: asset, targetSize: view.frame.size, contentMode: .default, options: options, resultHandler: { [weak self] (livePhoto, info) in
                    if livePhoto != nil {
                        self?.livePhotoView.livePhoto = livePhoto
                        self?.livePhotoView.startPlayback(with: .full)
                    }
                })
            } else {
                view.addSubview(imageView)
                imageView.snp.makeConstraints({ (make) in
                    if #available(iOS 11.0, *) {
                        make.edges.equalTo(view.safeAreaLayoutGuide)
                    } else {
                        make.edges.equalToSuperview()
                    }
                })
                
                if #available(iOS 11.0, *) {
                    if asset.playbackStyle == .imageAnimated {
                        imageView.image = nil
                        
                        let options = PHImageRequestOptions()
                        options.isNetworkAccessAllowed = true
                        options.progressHandler = { (progress, error, stop, info) in
                            DispatchQueue.main.async {
                                if progress < 1 {
                                    if self.indicator.isAnimating == false {
                                        self.indicator.startAnimating()
                                    }
                                } else {
                                    self.indicator.stopAnimating()
                                }
                            }
                        }
                        PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, _, _, _) in
                            if data != nil {
                                self.getGifImagesFrom(data: data!, completion: { (images, duration) in
                                    self.imageView.animationImages = images
                                    self.imageView.animationDuration = duration
                                    self.imageView.animationRepeatCount = 0 // 无限循环
                                    self.imageView.startAnimating()
                                })
                            }
                        })
                    } else {
                        self.imageView.stopAnimating()
                        self.imageView.animationImages = nil
                        
                        let options = PHImageRequestOptions()
                        options.isNetworkAccessAllowed = true
                        options.progressHandler = { (progress, error, stop, info) in
                            DispatchQueue.main.async {
                                if progress < 1 {
                                    if self.indicator.isAnimating == false {
                                        self.indicator.startAnimating()
                                    }
                                } else {
                                    self.indicator.stopAnimating()
                                }
                            }
                        }
                        PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, _, _, _) in
                            if data != nil {
                                let image = UIImage.init(data: data!)
                                self.imageView.image = image
                            }
                        })
                    }
                } else {
                    self.imageView.stopAnimating()
                    self.imageView.animationImages = nil
                    
                    let options = PHImageRequestOptions()
                    options.isNetworkAccessAllowed = true
                    options.progressHandler = { (progress, error, stop, info) in
                        DispatchQueue.main.async {
                            if progress < 1 {
                                if self.indicator.isAnimating == false {
                                    self.indicator.startAnimating()
                                }
                            } else {
                                self.indicator.stopAnimating()
                            }
                        }
                    }
                    PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, _, _, _) in
                        if data != nil {
                            let image = UIImage.init(data: data!)
                            self.imageView.image = image
                        }
                    })
                }
            }
        } else {
            view.addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                if #available(iOS 11.0, *) {
                    make.edges.equalTo(view.safeAreaLayoutGuide)
                } else {
                    make.edges.equalToSuperview()
                }
            })
            
            if #available(iOS 11.0, *) {
                if asset.playbackStyle == .imageAnimated {
                    imageView.image = nil
                    
                    let options = PHImageRequestOptions()
                    options.isNetworkAccessAllowed = true
                    options.progressHandler = { (progress, error, stop, info) in
                        DispatchQueue.main.async {
                            if progress < 1 {
                                if self.indicator.isAnimating == false {
                                    self.indicator.startAnimating()
                                }
                            } else {
                                self.indicator.stopAnimating()
                            }
                        }
                    }
                    PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, _, _, _) in
                        if data != nil {
                            self.getGifImagesFrom(data: data!, completion: { (images, duration) in
                                self.imageView.animationImages = images
                                self.imageView.animationDuration = duration
                                self.imageView.animationRepeatCount = 0 // 无限循环
                                self.imageView.startAnimating()
                            })
                        }
                    })
                } else {
                    self.imageView.stopAnimating()
                    self.imageView.animationImages = nil
                    
                    let options = PHImageRequestOptions()
                    options.isNetworkAccessAllowed = true
                    options.progressHandler = { (progress, error, stop, info) in
                        DispatchQueue.main.async {
                            if progress < 1 {
                                if self.indicator.isAnimating == false {
                                    self.indicator.startAnimating()
                                }
                            } else {
                                self.indicator.stopAnimating()
                            }
                        }
                    }
                    PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, _, _, _) in
                        if data != nil {
                            let image = UIImage.init(data: data!)
                            self.imageView.image = image
                        }
                    })
                }
            } else {
                self.imageView.stopAnimating()
                self.imageView.animationImages = nil
                
                let options = PHImageRequestOptions()
                options.isNetworkAccessAllowed = true
                options.progressHandler = { (progress, error, stop, info) in
                    DispatchQueue.main.async {
                        if progress < 1 {
                            if self.indicator.isAnimating == false {
                                self.indicator.startAnimating()
                            }
                        } else {
                            self.indicator.stopAnimating()
                        }
                    }
                }
                PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, _, _, _) in
                    if data != nil {
                        let image = UIImage.init(data: data!)
                        self.imageView.image = image
                    }
                })
            }
        }
    }


}
