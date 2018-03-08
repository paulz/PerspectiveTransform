import XCTest
import PerspectiveTransform

class PerformanceTest: XCTestCase {

    static let reasonableTestDurationMs = 100
    var repeatTimes = PerformanceTest.reasonableTestDurationMs * 1000
    let startRect = CGRect(origin: CGPoint.zero,
                           size: CGSize(width: 152,
                                        height: 122))
    let destinationRect = CGRect(
        origin: CGPoint(x: 100,
                        y: 100),
        size: CGSize(width: 200,
                     height: 200)
    )

    func testProjectiveTransformPerformance() {
        let testData = createTestPath()
        measure {
            repeatTransform(path: testData)
        }
    }

    func testAlgebraicSolution() {
        let points = [
            CGPoint(x: 108.315837, y: 80.1687782),
            CGPoint(x: 377.282671, y: 41.4352201),
            CGPoint(x: 193.321418, y: 330.023027),
            CGPoint(x: 459.781253, y: 251.836131),
            ]

        let destination = QuadrilateralCalc()
        destination.topLeft = points[0]
        destination.topRight = points[1]
        destination.bottomLeft = points[2]
        destination.bottomRight = points[3]

        let start = QuadrilateralCalc()
        let overlayFrame = CGRect(x: 0, y: 0, width: 1, height: 1)
        start.topLeft = CGPoint(x: overlayFrame.minX, y: overlayFrame.minY)
        start.topRight = CGPoint(x: overlayFrame.maxX, y: overlayFrame.minY)
        start.bottomLeft = CGPoint(x: overlayFrame.minX, y: overlayFrame.maxY)
        start.topLeft = CGPoint(x: overlayFrame.maxX, y: overlayFrame.maxY)

        measure {
            repeatTimes.times {
                _ = start.rectToQuad(rect: start.box(), quad: destination)
            }
        }
    }

    func testProjectiveTransformFromPoints() {
        let createNewPerspectivesTimes = 10_000
        repeatTimes /= createNewPerspectivesTimes
        measure {
            createNewPerspectivesTimes.times {
                let testData = createTestPath()
                repeatTransform(path: testData)
            }
        }
    }

    private struct Path {
        let start:Perspective
        let destination:Perspective

        func performProjectiveTransform() {
            _ = start.projectiveTransform(destination: destination)
        }
    }

    private func createTestPath() -> Path {
        return Path(start: Perspective(startRect),
                    destination: Perspective(destinationRect))
    }
    
    private func repeatTransform(path: Path) {
        repeatTimes.times {
            path.performProjectiveTransform()
        }
    }
}
