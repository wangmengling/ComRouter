Pod::Spec.new do |s|
  s.name = 'ComRouter'
  s.version = '1.0.2'
  #s.license = 'MIT'
  # s.license  = { :type => "MIT", :file => "https://github.com/wangmengling/ComRouter" }
  s.license          =   { :type => 'MIT', :file => 'LICENSE' }
  s.summary = 'Elegant HTTP Networking in Swift'
  s.homepage = 'https://github.com/wangmengling/ComRouter'
  s.social_media_url = 'https://github.com/wangmengling/ComRouter'
  s.authors = { 'wangmengling' => '294025529@qq.com' }
  s.source = { :git => 'https://github.com/wangmengling/ComRouter.git', :tag => '1.0.2' }

  s.ios.deployment_target = '9.0'
  # s.osx.deployment_target = '10.10'
  # s.tvos.deployment_target = '9.0'
  # s.watchos.deployment_target = '2.0'

  # s.source_files  = "Source", "Source/*.{h,m,swift}"
  s.source_files =  'Source/*.swift'
end
