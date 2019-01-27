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

+ (std::vector<Point2d>)matrixWithQuadrilateral:(Quadrilateral)origin {
    std::vector<Point2d> vec;
    vec.push_back(Point2d(origin.upperLeft.x, origin.upperLeft.y));
    vec.push_back(Point2d(origin.upperRight.x, origin.upperRight.y));
    vec.push_back(Point2d(origin.lowerRight.x, origin.lowerRight.y));
    vec.push_back(Point2d(origin.lowerLeft.x, origin.lowerLeft.y));
    return vec;
}


+ (CATransform3D)findHomographyFromQuadrilateral:(Quadrilateral)origin toQuadrilateral:(Quadrilateral)destination {
    std::vector<Point2d> start = [self matrixWithQuadrilateral:origin];
    std::vector<Point2d> end = [self matrixWithQuadrilateral:destination];
    Mat H = findHomography(start, end);
    return [self transform3DWithArray:H];
}
//
//+ (CATransform3D)perspectiveTransform:(Quadrilateral)origin toQuadrilateral:(Quadrilateral)destination {
//    CvPoint2D32f *cvsrc = [self openCVMatrixWithQuadrilateral:origin];
//    CvMat *src_mat = cvCreateMat( 4, 2, CV_32FC1 );
//    cvSetData(src_mat, cvsrc, sizeof(CvPoint2D32f));
//
//    CvPoint2D32f *cvdst = [self openCVMatrixWithQuadrilateral:destination];
//    CvMat *dst_mat = cvCreateMat( 4, 2, CV_32FC1 );
//    cvSetData(dst_mat, cvdst, sizeof(CvPoint2D32f));
//
//    CvMat *H = cvCreateMat(3,3,CV_32FC1);
//    cvGetPerspectiveTransform(cvsrc, cvdst, H);
//    cvReleaseMat(&src_mat);
//    cvReleaseMat(&dst_mat);
//
//    CATransform3D transform = [self transform3DWithCMatrix:H->data.fl];
//    cvReleaseMat(&H);
//
//    return transform;
//}
//
@end

