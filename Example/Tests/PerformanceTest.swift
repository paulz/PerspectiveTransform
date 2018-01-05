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
