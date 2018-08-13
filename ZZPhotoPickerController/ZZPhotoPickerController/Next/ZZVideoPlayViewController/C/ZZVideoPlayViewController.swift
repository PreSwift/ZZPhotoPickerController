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

class ZZVideoPlayViewController: UIViewController {

    var leftButton: UIButton!
    var rightButton:UIButton!
    lazy var avPlayer: AVPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var pauseImageView: UIImageView!
    var tapGesture: UITapGestureRecognizer!
    var viewModel: ZZVideoPlayViewModel!
    
    var asset: AVAsset!
    
    @objc dynamic var playerItem: AVPlayerItem? {
        didSet {
            avPlayer.replaceCurrentItem(with: playerItem)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        leftButton = UIButton()
        leftButton.setImage(UIImage.init(named: "ZZPhoto_nav_back", in: imageBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
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
        
        pauseImageView = UIImageView.init(image: UIImage.init(named: "ZZPhoto_play", in: imageBundle, compatibleWith: nil))
        pauseImageView.isHidden = true
        view.addSubview(pauseImageView)
        pauseImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        avPlayerLayer = AVPlayerLayer.init(player: avPlayer)
        if #available(iOS 11.0, *) {
            avPlayerLayer.frame = CGRect.init(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        } else {
            avPlayerLayer.frame = view.frame
        }
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        if asset != nil {
            playerItem = AVPlayerItem.init(asset: asset)
        }
        
        viewModel = ZZVideoPlayViewModel.init(target: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
