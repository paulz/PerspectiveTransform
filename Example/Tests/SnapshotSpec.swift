import Quick
import Nimble
import Nimble_Snapshots
import PerspectiveTransform
import Foundation

class SnapshotSpec: QuickSpec {
    override func spec() {
        describe("overlay placement") {
            var containerView : UIView!
            var overlayView : UIView!

            func testImage(named imageName: String) -> UIImage {
                return UIImage(named: imageName,
                               in: Bundle(for: type(of: self)),
                               compatibleWith: nil)!
            }

            beforeEach {
                containerView = UIImageView(image: testImage(named: "container.jpg"))
                overlayView = UIImageView(image: testImage(named: "sky.jpg"))
                containerView.addSubview(overlayView)
            }

            context("in perspective") {
                beforeEach {
                    overlayView.resetAnchorPoint()
                    let start = Perspective(overlayView.frame)

                    // see file://with-overlay.svg for overlay coordinates
                    let destination = Perspective(
                        CGPoint(x: 108.315837, y: 80.1687782),
                        CGPoint(x: 377.282671, y: 41.4352201),
                        CGPoint(x: 193.321418, y: 330.023027),
                        CGPoint(x: 459.781253, y: 251.836131)
                    )
                    overlayView.layer.transform = start.projectiveTransform(destination: destination)
                }

                it("should look as expected") {
                    expect(containerView).to(haveValidSnapshot(usesDrawRect:true))
                }
            }
        }
    }
}
