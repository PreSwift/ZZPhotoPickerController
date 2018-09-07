//
//  ZZVideoPlayViewModel.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 8/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa
import Photos

class ZZVideoPlayViewModel: NSObject {

    var photoOperationService: ZZPhotoOperationService
    weak var target: ZZVideoPlayViewController!
    
    var isPlayingWhenLost: Bool = false
    var time: CMTime = kCMTimeZero
    
    let disposeBag = DisposeBag()
    
    required init(target: ZZVideoPlayViewController, photoOperationService: ZZPhotoOperationService) {
        self.photoOperationService = photoOperationService
        super.init()
        self.target = target
        
        self.target.rx.observeWeakly(AVPlayerItem.self, "playerItem").subscribe(onNext: { [weak self] (playerItem) in
            guard let strongSelf = self else { return }
            if let newItem = playerItem {
                strongSelf.addObserver(newItem: newItem)
            }
        }).disposed(by: disposeBag)
        
        // 监听选中改变预览按钮状态
        self.photoOperationService.selectedAssets.bind { [weak self] assets in
            guard let strongSelf = self else { return }
            let isEnabled = assets.count > 0 ? true : false
            if isEnabled {
                strongSelf.target.rightButton.setTitle("下一步(\(assets.count))", for: .normal)
            } else {
                strongSelf.target.rightButton.setTitle("下一步", for: .normal)
            }
            
            let asset = strongSelf.target.asset
            let newAssets = strongSelf.photoOperationService.selectedAssets.value
            if let _ = newAssets.index(of: asset) {
                strongSelf.target.checkMark.isSelected = true
            } else {
                strongSelf.target.checkMark.isSelected = false
            }
        }.disposed(by: disposeBag)
        
        (self.target.leftButton.rx.tap).subscribe(onNext: { [weak self] (_) in
            self?.target.avPlayer.pause()
            self?.target.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        (self.target.rightButton.rx.tap).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            if let rootVC = strongSelf.target.navigationController as? ZZPhotoPickerController {
                rootVC.dismiss(animated: true, completion: {
                    var newAssets = strongSelf.photoOperationService.selectedAssets.value
                    if newAssets.count == 0 {
                        let asset = strongSelf.target.asset
                        newAssets.append(asset)
                        strongSelf.photoOperationService.selectedAssets.accept(newAssets)
                    }
                    
                    rootVC.zzDelegate?.photoPickerController!(rootVC, didSelect: [strongSelf.target.asset])
                })
            }
        }).disposed(by: disposeBag)
        
        self.target.tapGesture.rx.event.subscribe(onNext: { [weak self] (gesture) in
            guard let strongSelf = self else { return }
            if strongSelf.target.avPlayer.rate == 0 && strongSelf.target.avPlayer.status == .readyToPlay {
                strongSelf.play()
            } else if strongSelf.target.avPlayer.rate == 1 {
                strongSelf.pause()
            }
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.AVPlayerItemDidPlayToEndTime).subscribe(onNext: { [weak self] (notification) in
            guard let strongSelf = self else { return }
            strongSelf.target.avPlayer.seek(to: CMTime.init(seconds: 0, preferredTimescale: 1), completionHandler: { [weak self] (finish) in
                guard let strongSelf = self else { return }
                if finish {
                    strongSelf.play()
                }
            })
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIApplicationWillResignActive).subscribe(onNext: { [weak self] (notification) in
            guard let strongSelf = self else { return }
            strongSelf.isPlayingWhenLost = strongSelf.target.avPlayer.rate == 1
            strongSelf.pause()
            strongSelf.time = strongSelf.target.avPlayer.currentTime()
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIApplicationDidBecomeActive).subscribe(onNext: { [weak self] (notification) in
            guard let strongSelf = self else { return }
            strongSelf.target.avPlayer.seek(to: strongSelf.time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { (finished) in
                if finished {
                    if strongSelf.isPlayingWhenLost {
                        strongSelf.play()
                    }
                }
            })
        }).disposed(by: disposeBag)
        
        (target.checkMark.rx.tap).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            let asset = strongSelf.target.asset
            var newAssets = strongSelf.photoOperationService.selectedAssets.value
            if let index = newAssets.index(of: asset) {
                newAssets.remove(at: index)
            } else {
                let max = strongSelf.photoOperationService.maxSelectCount
                if newAssets.count >= max {
                    ZZPhotoAlertView.show("最多可以选择\(max)个视频")
                } else {
                    newAssets.append(asset)
                }
            }
            strongSelf.photoOperationService.selectedAssets.accept(newAssets)
        }).disposed(by: disposeBag)
    }
    
    
    
    func addObserver(newItem: AVPlayerItem) {
        newItem.rx.observeWeakly(NSNumber.self, "status").take(2).subscribe(onNext: { [weak self] (status) in
            guard let strongSelf = self else { return }
            if let newStatus = status {
                if newStatus.intValue == AVPlayerItemStatus.readyToPlay.rawValue {
                    strongSelf.play()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func play() {
        target.avPlayer.play()
        target.pauseImageView.isHidden = true
    }
    
    func pause() {
        target.avPlayer.pause()
        target.pauseImageView.isHidden = false
    }
    
    deinit {
        print(self)
    }
    
}
