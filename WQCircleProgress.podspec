
Pod::Spec.new do |s|

s.name         = "WQCircleProgress"
s.version      = "0.0.3"
s.summary      = "iOS项目中，彩色圆环的动态滚动"
s.homepage     = "https://github.com/WQiOS/WQCircleProgress"
s.license      = "MIT"
s.author       = { "王强" => "1570375769@qq.com" }
s.platform     = :ios, "8.0" #平台及支持的最低版本
s.requires_arc = true # 是否启用ARC
s.source       = { :git => "https://github.com/WQiOS/WQCircleProgress.git", :tag => "#{s.version}" }
s.source_files  = "WQCircleProgress/*.{h,m}"
s.ios.framework  = 'UIKit'

end
