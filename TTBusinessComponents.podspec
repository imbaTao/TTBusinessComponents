#
# Be sure to run `pod lib lint TTBusinessComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TTBusinessComponents'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TTBusinessComponents.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/imbatao@outlook.com/TTBusinessComponents'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'imbatao@outlook.com' => 'imbatao@outlook.com' }
  s.source           = { :git => 'https://github.com/imbatao@outlook.com/TTBusinessComponents.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = "5.0"
  s.ios.deployment_target = '11.0'

  s.source_files = 'TTBusinessComponents/TTBusinessComponents.swift'
  s.dependency "TTUIKit"
  s.dependency "MJRefresh"
  s.dependency "HandyJSON"
  
  # avatar
  s.subspec 'TTAvatar' do |ss|
    ss.source_files = 'TTBusinessComponents/TTAvatar/**/*'
    ss.dependency "Kingfisher"
  end

  # activeLabel
  s.subspec 'TTActiveLabel' do |ss|
    ss.source_files = 'TTBusinessComponents/TTActiveLabel/**/*'
    ss.dependency "ActiveLabel"
  end

  # TTStaticList
  s.subspec 'TTStaticList' do |ss|
    ss.source_files = 'TTBusinessComponents/TTStaticList/**/*'
  end

  # customTableView
  s.subspec 'TTCustomListView' do |ss|
    ss.source_files = 'TTBusinessComponents/TTCustomListView/**/*'
    ss.dependency 'TTUIKit/TTComponents/TTListView'
  end
  
  # tabbar
  s.subspec 'TTTabbar' do |ss|
    ss.source_files = 'TTBusinessComponents/TTTabbar/**/*'
    ss.dependency 'TTUIKit/TTComponents/TTListView'
  end
  
  # codeInputBar
  s.subspec 'TTAuthCodeInputBar' do |ss|
    ss.source_files = 'TTBusinessComponents/TTAuthCodeInputBar/**/*'
  end
  
  

end
