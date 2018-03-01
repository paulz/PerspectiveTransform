// OpenCV needs to be installed
// brew install opencv
#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"

@implementation OpenCVWrapper
+ (CATransform3D)transformQuadrilateral:(Quadrilateral)origin toQuadrilateral:(Quadrilateral)destination {

    CvPoint2D32f *cvsrc = [self openCVMatrixWithQuadrilateral:origin];
    CvMat *src_mat = cvCreateMat( 4, 2, CV_32FC1 );
    cvSetData(src_mat, cvsrc, sizeof(CvPoint2D32f));

    CvPoint2D32f *cvdst = [self openCVMatrixWithQuadrilateral:destination];
    CvMat *dst_mat = cvCreateMat( 4, 2, CV_32FC1 );
    cvSetData(dst_mat, cvdst, sizeof(CvPoint2D32f));

    CvMat *H = cvCreateMat(3,3,CV_32FC1);
    cvFindHomography(src_mat, dst_mat, H);
    cvReleaseMat(&src_mat);
    cvReleaseMat(&dst_mat);

    CATransform3D transform = [self transform3DWithCMatrix:H->data.fl];
    cvReleaseMat(&H);

    return transform;
}

+ (CvPoint2D32f *)openCVMatrixWithQuadrilateral:(Quadrilateral)origin {

    CvPoint2D32f *cvsrc = (CvPoint2D32f *)malloc(4*sizeof(CvPoint2D32f));
    cvsrc[0].x = origin.upperLeft.x;
    cvsrc[0].y = origin.upperLeft.y;
    cvsrc[1].x = origin.upperRight.x;
    cvsrc[1].y = origin.upperRight.y;
    cvsrc[2].x = origin.lowerRight.x;
    cvsrc[2].y = origin.lowerRight.y;
    cvsrc[3].x = origin.lowerLeft.x;
    cvsrc[3].y = origin.lowerLeft.y;
    return cvsrc;
}

+ (CATransform3D)transform3DWithCMatrix:(float *)matrix {
    CATransform3D transform = CATransform3DIdentity;

    transform.m11 = matrix[0];
    transform.m21 = matrix[1];
    transform.m41 = matrix[2];

    transform.m12 = matrix[3];
    transform.m22 = matrix[4];
    transform.m42 = matrix[5];

    transform.m14 = matrix[6];
    transform.m24 = matrix[7];
    transform.m44 = matrix[8];

    return transform;
}
    @end
