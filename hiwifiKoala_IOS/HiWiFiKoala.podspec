Pod::Spec.new do |s|
  s.name         = 'HiWiFiKoala'
  s.version      = '0.0.1'
  s.license      =  :type => '<#License#>'
  s.homepage     = '<#Homepage URL#>'
  s.authors      =  '<#Author Name#>' => '<#Author Email#>'
  s.summary      = '<#Summary (Up to 140 characters#>'

# Source Info
  s.platform     =  :ios, '<#iOS Platform#>'
  s.source       =  :git => '<#Github Repo URL#>', :tag => '<#Tag name#>'
  s.source_files = '<#Resources#>'
  s.framework    =  '<#Required Frameworks#>'

  s.requires_arc = true
  
# Pod Dependencies
  s.dependencies =	pod 'pop', '~> 1.0.6'
  s.dependencies =	pod 'AFNetworking', '~> 2.4.1'
  s.dependencies =	pod 'SDWebImage', '~> 3.7.1'
  s.dependencies =	pod 'ReactiveCocoa', '~> 2.3.1'
  s.dependencies =	pod 'SVProgressHUD', '~> 1.0'
  s.dependencies =	pod 'CocoaLumberjack'

end