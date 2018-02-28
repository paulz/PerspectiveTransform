//
//  OpenCV_Spec.h
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 2/26/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

typedef struct Quadrilateral {
    CGPoint upperLeft;
    CGPoint upperRight;
    CGPoint lowerRight;
    CGPoint lowerLeft;
} Quadrilateral;


@interface OpenCVWrapper: NSObject
+ (CATransform3D)transformQuadrilateral:(Quadrilateral)origin
                        toQuadrilateral:(Quadrilateral)destination;
    @end
