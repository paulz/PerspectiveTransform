//
//  OpenCV_Spec.h
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/26/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#ifndef OpenCV_Spec_h
#define OpenCV_Spec_h

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

typedef struct Quadrilateral {
    CGPoint upperLeft;
    CGPoint upperRight;
    CGPoint lowerRight;
    CGPoint lowerLeft;
} Quadrilateral;


@interface OpenCVWrapper : NSObject
- (BOOL)canBeCalledFromSwift;
+ (CATransform3D)transformQuadrilateral:(Quadrilateral)origin toQuadrilateral:(Quadrilateral)destination;
    @end



#endif /* OpenCV_Spec_h */

