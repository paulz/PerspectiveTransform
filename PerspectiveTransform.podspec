Pod::Spec.new do |s|
  s.cocoapods_version = '>=1.4.0'
  s.name              = 'PerspectiveTransform'
  s.version           = '0.2.0'
  s.summary           = 'Perspective Transform calculates CATransform3D'
  s.description       = <<-DESC
  Calculates CATransform3D to transform rectangular frame to convex quadrilateral
  Allows to overlay images in UIView given 4 points.
                       DESC
  authorPage          = 'https://github.com/paulz'
  s.homepage          = "#{authorPage}/#{s.name}"
  s.screenshots       = "#{s.homepage}/wiki/images/container-with-green-polygon.png"
  s.license           = { :type => 'MIT' }
  s.author            = { 'Paul Zabelin' => authorPage }
  s.source            = { :git => "#{s.homepage}.git", :tag => s.version.to_s }
  s.social_media_url  = 'https://twitter.com/iospaulz'

  s.platform      = :ios, '11.0'
  s.swift_version = '4.0'
  s.source_files  = 'Pod/Classes/**/*'
  s.frameworks    = 'UIKit', 'CoreGraphics', 'QuartzCore'
end
