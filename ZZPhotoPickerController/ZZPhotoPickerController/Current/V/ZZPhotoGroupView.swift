//
//  ZZPhotoGroupView.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 6/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import SnapKit

class ZZPhotoGroupView: UIButton {
    
    private(set) var backgroundView: UIView!
    private(set) var tableView: UITableView!
    private var viewHeight: CGFloat = 0
    private var navHeight: CGFloat = 0
    
    var viewModel: ZZPhotoGroupViewModel!
    
    required init(photoOperationService: ZZPhotoOperationService) {
        super.init(frame: .zero)
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(self)
        self.frame = window.bounds
        
        navHeight = UIApplication.shared.statusBarFrame.height + (UIApplication.shared.keyWindow!.rootViewController?.children.first?.navigationController?.navigationBar.frame.height ?? 44)
        
        self.viewHeight = 66.0 * CGFloat(photoOperationService.groups.value.count)
        let heightCount = UIScreen.main.bounds.height >= 667 ? 5 : 4
        self.viewHeight = photoOperationService.groups.value.count >= heightCount ? 66.0 * CGFloat(heightCount) : self.viewHeight
        
        backgroundView = UIView.init(frame: CGRect.init(x: 0, y: navHeight, width: bounds.width, height: bounds.height - navHeight))
        backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
        backgroundView.alpha = 0
        backgroundView.clipsToBounds = true
        addSubview(backgroundView)
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: -viewHeight, width: bounds.width, height: viewHeight), style: .plain)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 66
        tableView.alpha = 0
        tableView.register(ZZPhotoGroupTableViewCell.self, forCellReuseIdentifier: ZZPhotoGroupTableViewCell.cellID)
        backgroundView.addSubview(tableView)
        
        viewModel = ZZPhotoGroupViewModel.init(target: self, photoOperationService: photoOperationService)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 1
            self.tableView.alpha = 1
            self.tableView.transform = CGAffineTransform.init(translationX: 0, y: self.viewHeight)
        }, completion: { finished in
            
        })
    }
    
    func dismiss() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeLinear, animations: {
            self.backgroundView.alpha = 0
            self.tableView.alpha = 0
            self.tableView.transform = CGAffineTransform.identity
        }, completion: { finished in
            self.removeFromSuperview()
        })
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if point.y > navHeight + viewHeight || point.y < navHeight {
            return self
        } else {
            return tableView
        }
    }
    
    deinit {
//        print(self)
    }
}
