# FTroulette

[![CI Status](https://img.shields.io/travis/1085192695@qq.com/FTroulette.svg?style=flat)](https://travis-ci.org/1085192695@qq.com/FTroulette)
[![Version](https://img.shields.io/cocoapods/v/FTroulette.svg?style=flat)](https://cocoapods.org/pods/FTroulette)
[![License](https://img.shields.io/cocoapods/l/FTroulette.svg?style=flat)](https://github.com/520coding/FTroulette/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/FTroulette.svg?style=flat)](https://cocoapods.org/pods/FTroulette)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FTroulette is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FTroulette'
```

## Principle

1.以触碰点P与圆心O1为起始边，对±θ角范围内的刻度线进行偏移。角θ可根据三角形O1O2A，利用余弦定理，已知三边求角：a=r，b=R，c=R-d 代入即可求得α，即θ

![Image text](https://github.com/520coding/FTroulette/blob/master/ScreenShots/%E4%BD%99%E5%BC%A6%E5%AE%9A%E7%90%86.svg)

<img src="https://github.com/520coding/FTroulette/blob/master/ScreenShots/roulette1.png" /><br/>

2.原刻度线ab，偏移后得到新刻度线a'b'，新刻度线的位置L，可根据三角形O1O2a'，利用余弦定理结合完全平方公式，已知两边和一角求第三边：∠γ=∠α-∠β，a=R-d，c=r 代入即可求得b，即L

![Image text](https://github.com/520coding/FTroulette/blob/master/ScreenShots/%E4%BD%99%E5%BC%A6%E5%AE%9A%E7%90%862.svg)

<img src="https://github.com/520coding/FTroulette/blob/master/ScreenShots/roulette2.png" /><br/>

## Demo
![Image text](https://github.com/520coding/FTroulette/blob/master/ScreenShots/demo.gif)

注意：如遇到图片加载缓慢或失败，请参照——[解决办法](https://blog.csdn.net/u011583927/article/details/104384169?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param)<br />

## Author

794751446@qq.com, 1085192695@qq.com

## License

FTroulette is available under the MIT license. See the LICENSE file for more info.
