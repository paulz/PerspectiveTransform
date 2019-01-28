#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdocumentation"
/**
 OpenCV library is dynamically linked, to install OpenCV:

 brew install opencv
 */
#import <opencv2/opencv.hpp>
#pragma GCC diagnostic pop
#import "OpenCVWrapper.h"

using namespace cv;

static Point2f convert(CGPoint point) {
    return Point2f(point.x, point.y);
}

static Mat convert(Quadrilateral quad) {
    Mat matrix = Mat();
    matrix.push_back(convert(quad.upperLeft));
    matrix.push_back(convert(quad.upperRight));
    matrix.push_back(convert(quad.lowerRight));
    matrix.push_back(convert(quad.lowerLeft));
    return matrix;
}

static CATransform3D convert(Mat m) {
    CATransform3D transform = CATransform3DIdentity;
    transform.m11 = m.at<CGFloat>(0, 0);
    transform.m21 = m.at<CGFloat>(0, 1);
    transform.m41 = m.at<CGFloat>(0, 2);

    transform.m12 = m.at<CGFloat>(1, 0);
    transform.m22 = m.at<CGFloat>(1, 1);
    transform.m42 = m.at<CGFloat>(1, 2);

    transform.m14 = m.at<CGFloat>(2, 0);
    transform.m24 = m.at<CGFloat>(2, 1);
    transform.m44 = m.at<CGFloat>(2, 2);
    return transform;
}

@implementation OpenCVWrapper

+ (CATransform3D)findHomographyFromQuadrilateral:(Quadrilateral)origin toQuadrilateral:(Quadrilateral)destination {
    return convert(findHomography(convert(origin), convert(destination)));
}

+ (CATransform3D)perspectiveTransform:(Quadrilateral)origin toQuadrilateral:(Quadrilateral)destination {
    return convert(getPerspectiveTransform(convert(origin), convert(destination)));
}
@end
