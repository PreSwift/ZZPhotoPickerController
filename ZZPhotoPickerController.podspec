Pod::Spec.new do |s|
s.name         = "ZZPhotoPickerController"
s.version      = "0.5.6"
s.summary      = "照片选择器."
s.homepage     = "https://github.com/PreSwift/ZZPhotoPickerController"
s.license              = { :type => "MIT", :file => "LICENSE" }
s.author             = { "周元素" => "1778031092@qq.com" }
s.source       = { :git => "https://github.com/PreSwift/ZZPhotoPickerController.git", :tag => s.version }
s.frameworks = 'Foundation', 'UIKit', 'CoreServices'

s.ios.deployment_target = '9.0'

s.source_files = 'ZZPhotoPickerController/ZZPhotoPickerController/**/*.swift'
s.resources = ['ZZPhotoPickerController/ZZPhotoPickerController/Resources/*.png']
s.requires_arc = true
s.swift_version = '4.2'

s.dependency  'RxSwift'
s.dependency  'RxCocoa'
s.dependency  'RxDataSources'
s.dependency  'SnapKit'
s.dependency  'QMUIKit'
end
