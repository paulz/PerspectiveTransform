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

@implementation OpenCVWrapper

+ (CATransform3D)transform3DWithArray:(Mat)m {
    CATransform3D transform = CATransform3DIdentity;
    transform.m11 = m.at<double>(0, 0);
    transform.m21 = m.at<double>(0, 1);
    transform.m41 = m.at<double>(0, 2);

    transform.m12 = m.at<double>(1, 0);
    transform.m22 = m.at<double>(1, 1);
    transform.m42 = m.at<double>(1, 2);

    transform.m14 = m.at<double>(2, 0);
    transform.m24 = m.at<double>(2, 1);
    transform.m44 = m.at<double>(2, 2);

    return transform;
}

+ (std::vector<Point2f>)vectorWithQuadrilateral:(Quadrilateral)origin {
    std::vector<Point2f> vec;
    vec.push_back(Point2f(origin.upperLeft.x, origin.upperLeft.y));
    vec.push_back(Point2f(origin.upperRight.x, origin.upperRight.y));
    vec.push_back(Point2f(origin.lowerRight.x, origin.lowerRight.y));
    vec.push_back(Point2f(origin.lowerLeft.x, origin.lowerLeft.y));
    return vec;
}


+ (CATransform3D)findHomographyFromQuadrilateral:(Quadrilateral)origin toQuadrilateral:(Quadrilateral)destination {
    std::vector<Point2f> start = [self vectorWithQuadrilateral:origin];
    std::vector<Point2f> end = [self vectorWithQuadrilateral:destination];
    Mat H = findHomography(start, end);
    return [self transform3DWithArray:H];
}

+ (CATransform3D)perspectiveTransform:(Quadrilateral)origin toQuadrilateral:(Quadrilateral)destination {
    std::vector<Point2f> start = [self vectorWithQuadrilateral:origin];
    std::vector<Point2f> end = [self vectorWithQuadrilateral:destination];
    Mat H = getPerspectiveTransform(start, end);
    return [self transform3DWithArray:H];
}
@end
