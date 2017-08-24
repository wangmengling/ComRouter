Pod::Spec.new do |s|
  s.name = 'ComRouter'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'Elegant HTTP Networking in Swift'
  s.homepage = 'https://github.com/wangmengling/ComRouter'
  s.social_media_url = 'https://github.com/wangmengling/ComRouter'
  s.authors = { 'wangguozhong' => 'guo-zhong.wang@utsoft.cn' }
  s.source = { :git => 'https://github.com/wangmengling/ComRouter.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  # s.osx.deployment_target = '10.10'
  # s.tvos.deployment_target = '9.0'
  # s.watchos.deployment_target = '2.0'

  s.source_files = 'Source/*.swift'
end
