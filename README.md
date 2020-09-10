# Perspective Transform

[![macOS](https://github.com/paulz/PerspectiveTransform/workflows/macOS/badge.svg)](https://github.com/paulz/PerspectiveTransform/actions?query=workflow%3AmacOS)
[![iOS](https://github.com/paulz/PerspectiveTransform/workflows/iOS/badge.svg)](https://github.com/paulz/PerspectiveTransform/actions?query=workflow%3AiOS)
[![codecov](https://codecov.io/gh/paulz/PerspectiveTransform/branch/master/graph/badge.svg)](https://codecov.io/gh/paulz/PerspectiveTransform)
[![Version](https://img.shields.io/cocoapods/v/PerspectiveTransform.svg?style=flat)](http://cocoapods.org/pods/PerspectiveTransform)
[![License](https://img.shields.io/cocoapods/l/PerspectiveTransform.svg?style=flat)](http://cocoapods.org/pods/PerspectiveTransform)
[![Platform](https://img.shields.io/cocoapods/p/PerspectiveTransform.svg?style=flat)](http://cocoapods.org/pods/PerspectiveTransform)
[![Carthage compatible][carthage-badge]](https://github.com/Carthage/Carthage)
[![Swift][swift-badge]][swift-url]


PerspectiveTransform caclulates homogeneous transformation matrix for a view 3D projection in 2D. It can be used to place views within given image visual perspective using Core Animation `CATransform3D` and [`CALayer.tranform`](https://developer.apple.com/documentation/quartzcore/calayer/1410836-transform). Projection is caclulated between source and destination perspectives that are defined by 4 corners, assuming they form a [Quadrilateral](https://en.wikipedia.org/wiki/Quadrilateral).

## [CATransform3D](https://developer.apple.com/documentation/quartzcore/catransform3d)

To place an overlay image on top of a container image with matching persperctive we can use Core Animation transform matrix. `CATransform3D` is a tranformation matrix that is used to rotate, scale, translate, skew, and project the layer content. It can also be used to describe a perspective projectection of 2D shape in 3D space.

| Container  | Overlay | Combination |
| ------------- | ------------- | --- |
| <img src="https://raw.githubusercontent.com/paulz/PerspectiveTransform/master/Example/Tests/container.jpg" alt="Container"/>  | <img src="https://raw.githubusercontent.com/paulz/PerspectiveTransform/master/Example/Tests/sky.jpg" alt="Overlay"/>  | <img src="https://github.com/paulz/PerspectiveTransform/wiki/images/withOverlay-example.png" alt="Combined image"/> |

Core Animation allow applying `CATransform3D` to `CALayer` via `transform` property:

```swift
let layer = UIView().layer
layer.transform = CATransform3D(m11: sX,  m12: r12, m13: r13, m14: 0,
                                m21: r21, m22: sY,  m23: r23, m24: 0,
                                m31: r31, m32: r32, m33: 0,   m34: 0,
                                m41: tX,  m42: tY,  m43: 0,   m44: 1)
```
In detail `CATransform3D` is a 4 x 4 matrix which takes 16 parameters to build.

Translation and scale are represented by their axis components: (tX, tY) and (sX, sY) within the matrix.  While 3D rotation is represented by multiple values: r12, r21, r13, r31, r32, r23.

## Perspective Transform based on 4 corners

We can easily see 4 points with container image where the corners of the overlay image should be. In general it is a 4 point polygon. Using an SVG editor we can draw that polygon using container image as a background. Here is preview of the SVG file desribing placement of iPad screen corners

[<img src="https://github.com/paulz/PerspectiveTransform/blob/master/Example/Tests/with-overlay.svg" alt="SVG polygon"  width="50%"/>](https://github.com/paulz/PerspectiveTransform/blob/master/Example/Tests/with-overlay.svg)

Click image to see original SVG file defining `polygon` with `points`. From those 4 points we can calculate nessesary `CATransform3D` matrix using this `PerspectiveTransform` library.

## Visual Example

We can see how 4 points polygon fits on the background image:

<img src="https://github.com/paulz/PerspectiveTransform/wiki/images/container-with-green-polygon.png" alt="SVG polygon" width=50%/>

### SVG Points
We can even take coordinates of those 4 points from SVG file:

```xml
<polygon points="377.282671 41.4352201 459.781253 251.836131 193.321418 330.023027 108.315837 80.1687782 "></polygon>
```

Those are 4 pairs of X and Y coordinates:

```
377.282671 41.4352201
459.781253 251.836131
193.321418 330.023027
108.315837 80.1687782
```
### Swift Code Example
Here is complete example of placing overlay view using those coordinates:

```swift
import PerspectiveTransform

// note order: top left, top right, bottom left, bottom right
let destination = Perspective(
    CGPoint(x: 108.315837, y: 80.1687782),
    CGPoint(x: 377.282671, y: 41.4352201),
    CGPoint(x: 193.321418, y: 330.023027),
    CGPoint(x: 459.781253, y: 251.836131)
)

// Starting perspective is the current overlay frame
let start = Perspective(overlayView.frame)

// Caclulate CATransform3D from start to destination
overlayView.layer.transform = start.projectiveTransform(destination: destination)

```

### `CALayer` transform
Since `CALayer` transform is animatable property we can easily define smooth transition:

<img src="https://github.com/paulz/PerspectiveTransform/wiki/images/perspective-transform-animated.gif" alt="SVG polygon" width=50%/>


## Example Project

See [Example iOS project](https://github.com/paulz/PerspectiveTransform/tree/master/Example) illustating animation and interactive tranform within view controllers. To build Example project run `pod install` within Example folder.

Example project also includes [Swift Playground](https://github.com/paulz/PerspectiveTransform/tree/master/Example/PerspectiveTransform/Visual.playground) with couple of live examples.


## Installation

PerspectiveTransform is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PerspectiveTransform'
```

### Useful Links
 * [Explaining Homogeneous Coordinates & Projective Geometry](https://www.tomdalling.com/blog/modern-opengl/explaining-homogenous-coordinates-and-projective-geometry/)

## Author

Paul Zabelin, http://github.com/paulz

## License

PerspectiveTransform is available under the MIT license. See the LICENSE file for more info.

[swift-badge]: https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat
[swift-url]: https://swift.org
[carthage-badge]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
