//
//  ZZPhotoGroupViewModel.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 6/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Photos

class ZZPhotoGroupViewModel: NSObject {
    
    var photoOperationService: ZZPhotoOperationService
    weak var target: ZZPhotoGroupView!
    
    var result = PublishSubject<[SectionModel<String, ZZPhotoGroupModel>]>()
    let disposeBag = DisposeBag()
    
    required init(target: ZZPhotoGroupView, photoOperationService: ZZPhotoOperationService) {
        self.photoOperationService = photoOperationService
        super.init()
        self.target = target
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ZZPhotoGroupModel>>(configureCell: { (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: ZZPhotoGroupTableViewCell.cellID, for: indexPath) as! ZZPhotoGroupTableViewCell
            cell.update(group: element)
            return cell
        })
        
        result.bind(to: target.tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        photoOperationService.groups.subscribe(onNext: { [unowned self] (groups) in
            let section = SectionModel.init(model: "1", items: groups)
            self.result.onNext([section])
        }).disposed(by: disposeBag)
        
        target.rx.tap.subscribe { [unowned self] (_) in
            self.target.dismiss()
        }.disposed(by: disposeBag)
        
        target.tableView.rx.modelSelected(ZZPhotoGroupModel.self).subscribe(onNext: { [unowned self] (group) in
            self.photoOperationService.currentGroup = group
            self.target.dismiss()
        }).disposed(by: disposeBag)
    }
    
    deinit {
//        print(self)
    }
    
}
