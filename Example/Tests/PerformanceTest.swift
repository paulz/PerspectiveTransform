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

    /** shows perspective transform has the same performance as algebraic solution
     */
    func testProjectiveTransformPerformance() {
        let testData = createTestPath()
        measure {
            repeatTransform(path: testData)
        }
    }

    /** shows algebraic solution has the same performance as perspective transform
     */
    func testAlgebraicSolution() {
        let points = [
            CGPoint(x: 108.315837, y: 80.1687782),
            CGPoint(x: 377.282671, y: 41.4352201),
            CGPoint(x: 193.321418, y: 330.023027),
            CGPoint(x: 459.781253, y: 251.836131)
        ]

        let destination = QuadrilateralCalc()
        destination.topLeft = points[0]
        destination.topRight = points[1]
        destination.bottomLeft = points[2]
        destination.bottomRight = points[3]

        let start = QuadrilateralCalc()
        let corners = CGRect(x: 0, y: 0, width: 1, height: 1).corners()
        start.topLeft = corners[0]
        start.topRight = corners[1]
        start.bottomLeft = corners[2]
        start.topLeft = corners[3]

        measure {
            repeatTimes.times {
                _ = start.rectToQuad(rect: start.box(), quad: destination)
            }
        }
    }

    /** shows that creating perspective is 10,000 times slower then calculating transform
     */
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
        let start: Perspective
        let destination: Perspective

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
