import Quick
import Nimble
import Nimble_Snapshots
import PerspectiveTransform
import Foundation

public extension UIView {
    public func resetAnchorPoint() {
        let rect = frame
        layer.anchorPoint = CGPointZero
        frame = rect
    }
}

class SnapshotSpec: QuickSpec {
    override func spec() {
        describe("overlay placement") {
            var containerView : UIView!
            var overlayView : UIView!

            beforeEach {
                let bundle = NSBundle(forClass: SnapshotSpec.self)
                let containerImage = UIImage(named: "container.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
                containerView = UIImageView(image: containerImage)
                let overlayImage = UIImage(named: "sky.jpg", inBundle: bundle, compatibleWithTraitCollection: nil)
                overlayView = UIImageView(image: overlayImage)
                containerView.addSubview(overlayView)
            }

            context("in perspective") {
                beforeEach {
                    overlayView.resetAnchorPoint()
                    let start = Perspective(overlayView.frame)

                    // see file://with-overlay.svg for overlay coordinates
                    let destination = Perspective([
                        CGPoint(x: 108.315837, y: 80.1687782),
                        CGPoint(x: 377.282671, y: 41.4352201),
                        CGPoint(x: 193.321418, y: 330.023027),
                        CGPoint(x: 459.781253, y: 251.836131),
                        ])
                    overlayView.layer.transform = start.projectiveTransform(destination)
                }

                it("should look as expected") {
                    expect(containerView).to(haveValidSnapshot())
                }
            }
        }
    }
}
