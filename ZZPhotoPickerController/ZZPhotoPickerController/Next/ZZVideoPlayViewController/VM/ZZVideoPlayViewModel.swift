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

class ZZVideoPlayViewModel: NSObject {

    weak var target: ZZVideoPlayViewController!
    
    var isPlayingWhenLost: Bool = false
    
    let disposeBag = DisposeBag()
    
    required init(target: ZZVideoPlayViewController) {
        super.init()
        self.target = target
        
        self.target.rx.observeWeakly(AVPlayerItem.self, "playerItem").subscribe(onNext: { [weak self] (playerItem) in
            guard let strongSelf = self else { return }
            if let newItem = playerItem {
                strongSelf.addObserver(newItem: newItem)
            }
        }).disposed(by: disposeBag)
        
        (self.target.leftButton.rx.tap).subscribe(onNext: { [weak self] (_) in
            self?.target.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        (self.target.rightButton.rx.tap).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            if let rootVC = strongSelf.target.navigationController as? ZZPhotoPickerController {
                rootVC.zzDelegate?.photoPickerController!(rootVC, didSelectVideo: strongSelf.target.asset)
                rootVC.dismiss(animated: true, completion: nil)
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
                    strongSelf.target.avPlayer.play()
                }
            })
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIApplicationWillResignActive).subscribe(onNext: { [weak self] (notification) in
            guard let strongSelf = self else { return }
            strongSelf.isPlayingWhenLost = strongSelf.target.avPlayer.rate == 1
            strongSelf.pause()
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name.UIApplicationDidBecomeActive).subscribe(onNext: { [weak self] (notification) in
            guard let strongSelf = self else { return }
            if strongSelf.isPlayingWhenLost {
                strongSelf.play()
            }
        }).disposed(by: disposeBag)
    }
    
    func addObserver(newItem: AVPlayerItem) {
        newItem.rx.observeWeakly(NSNumber.self, "status").subscribe(onNext: { [weak self] (status) in
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
