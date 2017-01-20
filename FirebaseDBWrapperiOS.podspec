Pod::Spec.new do |s|
  s.name         = "FirebaseDBWrapperiOS"
  s.version      = "0.0.1"
  s.summary      = "Thin and easy-to-use wrapper for Firebase's Realtime Database"
  s.homepage     = "https://github.com/poisondminds/firebase-db-wrapper-ios"
  s.license      = 'Apache License, Version 2.0'
  s.authors      = {'Ryan Burns' => 'ryanburns31892@gmail.com'}
  s.source       = { :git => 'https://github.com/poisondminds/firebase-db-wrapper-ios.git',  :tag => s.version}
  s.social_media_url = 'http://twitter.com/daltoniam'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.source_files = 'Source/*.swift'
  s.requires_arc = 'true'

  s.dependency 'FirebaseStorage', '~> 1.0.5'
  s.dependency 'FirebaseDatabase', '~> 3.1.1'
end