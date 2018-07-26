//
//  ViewController.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 25/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa


class ViewController: UIViewController {

    var rightItem = UIBarButtonItem.init(barButtonSystemItem: .camera, target: nil, action: nil)
    
    @objc dynamic var message = "hangge.com"
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "照片选择器"
        navigationItem.rightBarButtonItem = rightItem

        
        _ = (rightItem.rx.tap).bind { [unowned self] in
            let vc = ZZPhotoPickerController()
            self.present(vc, animated: true, completion: nil)
        }
        
        
    }


}

