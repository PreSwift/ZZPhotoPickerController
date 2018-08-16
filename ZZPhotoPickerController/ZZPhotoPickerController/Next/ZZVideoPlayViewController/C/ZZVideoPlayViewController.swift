//
//  ZZVideoPlayViewController.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 8/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import AVKit
import SnapKit
import Photos

class ZZVideoPlayViewController: UIViewController {

    var leftButton: UIButton!
    var rightButton:UIButton!
    lazy var avPlayer: AVPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var pauseImageView: UIImageView!
    var tapGesture: UITapGestureRecognizer!
    var viewModel: ZZVideoPlayViewModel!
    
    private(set) lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        return indicator
    }()
    
    private(set) var asset: PHAsset
    
    @objc dynamic var playerItem: AVPlayerItem? {
        didSet {
            avPlayer.replaceCurrentItem(with: playerItem)
        }
    }
    
    required init(asset: PHAsset) {
        self.asset = asset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.1, alpha: 1)
        
        leftButton = UIButton()
        leftButton.isHidden = true
        leftButton.setImage(UIImage.init(named: "ZZPhoto_nav_back", in: self.imageBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.contentHorizontalAlignment = .left
        leftButton.tintColor = UIColor.white
        view.addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            } else {
                make.top.equalToSuperview().inset(15)
            }
            make.left.equalToSuperview().inset(10)
            make.size.equalTo(CGSize.init(width: 60, height: 30))
        }
        
        rightButton = UIButton()
        rightButton.isHidden = true
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        rightButton.setTitle("下一步", for: .normal)
        rightButton.layer.cornerRadius = 15
        rightButton.layer.masksToBounds = true
        rightButton.setBackgroundImage(UIImage.init(color: UIColor.orange.withAlphaComponent(0.8)), for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        view.addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(10)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            } else {
                make.top.equalToSuperview().inset(15)
            }
            make.height.equalTo(30)
        }
        
        pauseImageView = UIImageView.init(image: UIImage.init(named: "ZZPhoto_play", in: self.imageBundle, compatibleWith: nil))
        pauseImageView.isHidden = true
        view.addSubview(pauseImageView)
        pauseImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        avPlayerLayer = AVPlayerLayer.init(player: avPlayer)
        // 加入初始frame，防止抖动
        if #available(iOS 11.0, *) {
            avPlayerLayer.frame = CGRect.init(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        } else {
            avPlayerLayer.frame = view.frame
        }
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        let options = PHVideoRequestOptions()
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
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: { [weak self] (avAsset, audioMix, info) in
            guard let strongSelf = self else { return }
            if avAsset == nil {
                if let isInCloud = info?[PHImageResultIsInCloudKey] as? Bool {
                    if isInCloud == true {
                        DispatchQueue.main.async {
                            ZZPhotoAlertView.show("iCloud同步中")
                        }
                    }
                }
            } else {
                strongSelf.playerItem = AVPlayerItem.init(asset: avAsset!)
            }
        })
        
        viewModel = ZZVideoPlayViewModel.init(target: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // 自适应frame
        if #available(iOS 11.0, *) {
            avPlayerLayer.frame = CGRect.init(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        } else {
            avPlayerLayer.frame = view.frame
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController != nil {
            leftButton.isHidden = false
            rightButton.isHidden = false
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        print(self)
    }

}
