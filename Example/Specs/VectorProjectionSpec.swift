import Quick
import Nimble
import simd

class VectorProjectionSpec: QuickSpec {
    override func spec() {
        describe("vector projection") {
            it("should be 0 orthogonally") {
                let v12 = vector_float2(1,0)
                let v23 = vector_float2(0,1)
                let p = project(v12, v23)
                expect(p.x) == 0
                expect(p.y) == 0
            }
        }
    }
}
