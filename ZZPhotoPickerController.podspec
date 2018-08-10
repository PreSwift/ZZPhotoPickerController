Pod::Spec.new do |s|
s.name         = "ZZPhotoPickerController"
s.version      = "1.0.0"
s.ios.deployment_target = '9.0'
s.summary      = "照片选择器."
s.homepage     = "https://github.com/PreSwift/ZZPhotoPickerController"
s.license              = { :type => "MIT", :file => "LICENSE" }
s.author             = { "周元素" => "1778031092@qq.com" }
s.source       = { :git => "https://github.com/PreSwift/ZZPhotoPickerController.git", :tag => s.version }
#s.source_files  = "ZZPhotoPickerController/*"
s.resources          = "ZZPhotoPickerController/ZZPhotoPicker.bundle"
s.swift_version = '4.1'
s.frameworks = 'Foundation', 'UIKit'
s.vendored_frameworks = 'ZZPhotoPickerController/Products/ZZPhotoPickerController.framework'
s.requires_arc = true
s.dependency  'RxSwift'
s.dependency  'RxCocoa'
s.dependency  'RxDataSources'
s.dependency  'SnapKit'
end
