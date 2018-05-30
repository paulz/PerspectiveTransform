Pod::Spec.new do |s|
  s.cocoapods_version = '~> 1.5'
  s.name              = 'PerspectiveTransform'
  s.version           = '0.3.4'
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
  s.platform          = :ios, '11.0'
  s.swift_version     = '4.0'
  s.source_files      = 'Pod/Classes/**/*'
  s.frameworks        = 'UIKit', 'CoreGraphics', 'QuartzCore'
  s.test_spec 'UnitSpecs' do |ts|
      ts.source_files   = 'Example/Specs/**/*.{h,swift}', 'Example/Tests/*Helper.swift'
      ts.dependencies   = {
          'Quick' => '~> 1.3',
          'Nimble' => '~> 7.1'
      }
  end
  s.test_spec 'AppSpecs' do |ts|
      ts.requires_app_host = true
      ts.resources      = 'Example/Tests/**/*.{png,jpg,svg}'
      ts.source_files   = 'Example/Tests/**/*.{h,swift}', 'Example/PerspectiveTransform/resetAnchorPoint.swift'
      ts.dependencies   = {
          'Quick' => '~> 1.3',
          'Nimble-Snapshots' => '~> 6.7',
          'iOSSnapshotTestCase' => '~> 3.0'
      }
  end
end
