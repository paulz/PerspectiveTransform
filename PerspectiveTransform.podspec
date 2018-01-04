Pod::Spec.new do |s|
  s.name             = "PerspectiveTransform"
  s.version          = "0.2.0"
  s.summary          = "Perspective Transform calculates CATransform3D"
  s.description      = <<-DESC
  Calculates CATransform3D to transform rectangular frame to convex quadrilateral
  Allows to overlay images in UIView given 4 points.
                       DESC

  s.homepage         = "https://github.com/paulz/PerspectiveTransform"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { 'Paul Zabelin' => 'https://github.com/paulz' }
  s.source           = { :git => "https://github.com/paulz/PerspectiveTransform.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/iospaulz'

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'UIKit'
end
