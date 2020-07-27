//
//  TMrouletteView.m
//  roulette
//
//  Created by ymac on 20/07/2020.
//  Copyright © 2020 xxx. All rights reserved.
//

#import "TMrouletteView.h"
@interface TMrouletteView ()
@property (nonatomic, strong) NSMutableArray *layerArray;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *touchView;
@end

@implementation TMrouletteView
@synthesize normalRadius = _normalRadius;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (NSMutableArray *)layerArray {
    if (!_layerArray) {
        _layerArray = [NSMutableArray arrayWithCapacity:100];
    }
    return _layerArray;
}

- (void)updateView
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.layerArray.count > 0) {
        for (CAShapeLayer *layer in self.layerArray) {
            [layer removeFromSuperlayer];
        }
        [self.layerArray removeAllObjects];
    }
    [self addSubview:self.backgroundImageView];
    [self drawScaleWithDivideOfUint:_divideOfUint countOfUnit:_countOfUnit color:self.scaleColor normalWidth:self.scaleLineNormalWidth bigWidth:self.scaleLineBigWidth];
    [self addTouchView];
}

- (void)createRouletteWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue divideOfUint:(NSInteger)divideOfUint countOfUnit:(NSInteger)countOfUnit
{
    _minValue = minValue;
    _maxValue = maxValue;
    _divideOfUint = divideOfUint;
    _countOfUnit = countOfUnit;
    [self addSubview:self.backgroundImageView];
    [self drawScaleWithDivideOfUint:_divideOfUint countOfUnit:_countOfUnit color:self.scaleColor normalWidth:self.scaleLineNormalWidth bigWidth:self.scaleLineBigWidth];
    [self addTouchView];
}

- (void)drawScaleWithDivideOfUint:(NSInteger)divideOfUint countOfUnit:(NSInteger)countOfUnit color:(UIColor *)color normalWidth:(CGFloat)normalWidth bigWidth:(CGFloat)bigWidth {
    assert(countOfUnit > 0);
    for (NSInteger i = 0; i <= divideOfUint * countOfUnit; i++) {
        CAShapeLayer *perLayer = [self scaleIndex:i strokeColor:color];
        [self.layer addSublayer:perLayer];
        [self.layerArray addObject:perLayer];
    }
    
    CGFloat textAngel = M_PI * 2 / countOfUnit;
    for (NSUInteger i = 0; i < countOfUnit; i++) {
        CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        CGPoint point = [self calculateTextPositonWithArcCenter:center angle:textAngel * i];
        NSString *tickText = [NSString stringWithFormat:@"%ld", (long)(i * ((_maxValue - _minValue) / countOfUnit) + _minValue)];

        UILabel *text = [[UILabel alloc] initWithFrame:CGRectZero];
        text.text = tickText;
        text.font = [UIFont systemFontOfSize:14.f];
        text.textColor = color;
        text.textAlignment = NSTextAlignmentCenter;
        text.frame = CGRectMake(0, 0, 20, 20);
        text.center = point;
        [self addSubview:text];
        [self sendSubviewToBack:text];
    }

}

//计算文本中心位置
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center angle:(CGFloat)angle {
    CGFloat x = (self.normalRadius - 25) * cosf(angle + self.startAngle);
    CGFloat y = (self.normalRadius - 25) * sinf(angle + self.startAngle);
    return CGPointMake(center.x + x, center.y + y);
}

//获取刻度线图层
- (CAShapeLayer *)scaleIndex:(NSInteger)i strokeColor:(UIColor *_Nonnull)strokeColor {
    CGFloat perAngle = M_PI * 2 / (_divideOfUint * _countOfUnit);
    CGFloat startAngel = (self.startAngle + perAngle * i);
//    CGFloat endAngel = startAngel + perAngle / 5;
    CGFloat endAngel = startAngel + M_PI / 240;
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);

    UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.normalRadius startAngle:startAngel endAngle:endAngel clockwise:YES];
    CAShapeLayer *perLayer = [CAShapeLayer layer];
    perLayer.fillColor = [UIColor clearColor].CGColor;
    if ((i % _divideOfUint) == 0) {
        perLayer.strokeColor = strokeColor.CGColor;
        perLayer.lineWidth = _scaleLineBigWidth;
    } else {
        perLayer.strokeColor = strokeColor.CGColor;
        perLayer.lineWidth = _scaleLineNormalWidth;
    }
    perLayer.path = tickPath.CGPath;
    return perLayer;
}

//背景图片
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.image = [UIImage imageNamed:@"仪表盘new"];
        backgroundImageView.frame = CGRectMake(0, 0, self.normalRadius * 2 - 20, self.normalRadius * 2 - 20);
        CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        backgroundImageView.center = center;
        _backgroundImageView = backgroundImageView;
    }
    return _backgroundImageView;
}

#pragma mark   *** touch ***
- (void)addTouchView {
    UIView *touchView = [UIView new];
    self.touchView = touchView;
    [self insertSubview:touchView atIndex:0];
    touchView.backgroundColor = [UIColor clearColor];

    UILongPressGestureRecognizer *pan = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
    [self.touchView addGestureRecognizer:pan];
    pan.minimumPressDuration = 0;
    pan.allowableMovement = CGFLOAT_MAX;
    self.touchView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (void)touchAction:(UILongPressGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self resetRoulette];
        return;
    }
    CGPoint point = [pan locationInView:self.touchView];
    CGFloat pointAngle = 0;

    if (point.x > self.bounds.size.width / 2 && point.y > self.bounds.size.height / 2) {
        CGFloat tanValue = fabs(point.y - self.bounds.size.height / 2) / fabs(point.x - self.bounds.size.width / 2);
        CGFloat tanRadian = atan(tanValue);
        pointAngle = tanRadian;
    }
    if (point.x > self.bounds.size.width / 2 && point.y < self.bounds.size.height / 2) {
        CGFloat tanValue = fabs(point.x - self.bounds.size.width / 2) / fabs(point.y - self.bounds.size.height / 2);
        CGFloat tanRadian = atan(tanValue);
        pointAngle = self.startAngle + tanRadian;
    }
    if (point.x < self.bounds.size.width / 2 && point.y < self.bounds.size.height / 2) {
        CGFloat tanValue = fabs(point.y - self.bounds.size.height / 2) / fabs(point.x - self.bounds.size.width / 2);
        CGFloat tanRadian = atan(tanValue);
        pointAngle = M_PI + tanRadian;
    }
    if (point.x < self.bounds.size.width / 2 && point.y > self.bounds.size.height / 2) {
        CGFloat tanValue = fabs(point.x - self.bounds.size.width / 2) / fabs(point.y - self.bounds.size.height / 2);
        CGFloat tanRadian = atan(tanValue);
        pointAngle = M_PI_2 + tanRadian;
    }

    [self updateScaleLayer:pointAngle];
}

- (void)resetRoulette {
    if (self.layerArray.count > 0) {
        for (CAShapeLayer *layer in self.layerArray) {
            [layer removeFromSuperlayer];
        }
        [self.layerArray removeAllObjects];
    }
    for (NSInteger i = 0; i <  _divideOfUint * _countOfUnit; i++) {
        CAShapeLayer *perLayer = [self scaleIndex:i strokeColor:self.scaleColor];
        [self.layer addSublayer:perLayer];
        [self.layerArray addObject:perLayer];
    }
}

- (void)updateScaleLayer:(CGFloat)currentAngle {
    if (self.layerArray.count > 0) {
        for (CAShapeLayer *layer in self.layerArray) {
            [layer removeFromSuperlayer];
        }
        [self.layerArray removeAllObjects];
    }
    for (NSInteger i = 0; i <  _divideOfUint * _countOfUnit; i++) {
        CAShapeLayer *perLayer = [self newScaleIndex:i strokeColor:self.scaleColor angle:currentAngle];
        [self.layer addSublayer:perLayer];
        [self.layerArray addObject:perLayer];
    }
}

//获取刻度线图层
- (CAShapeLayer *)newScaleIndex:(NSInteger)i strokeColor:(UIColor *_Nonnull)strokeColor angle:(CGFloat)angle {
    CGFloat perAngle = M_PI * 2 / (_divideOfUint * _countOfUnit);
    CGFloat startAngel = (self.startAngle + perAngle * i);
//    CGFloat endAngel = startAngel + perAngle / 5;
    CGFloat endAngel = startAngel + M_PI / 240;
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);

    UIBezierPath *tickPath;
    CAShapeLayer *perLayer = [CAShapeLayer layer];
    perLayer.fillColor = [UIColor clearColor].CGColor;
    if ((i % _divideOfUint) == 0) {
        perLayer.strokeColor = strokeColor.CGColor;
        perLayer.lineWidth = _scaleLineBigWidth;
    } else {
        perLayer.strokeColor = strokeColor.CGColor;
        perLayer.lineWidth = _scaleLineNormalWidth;
    }
    
    CGFloat limit = [self calculateLimitAngle];
    if (fabs(startAngel - angle) < limit || fabs(startAngel - angle + 2 * M_PI) < limit || fabs(startAngel - angle - 2 * M_PI) < limit) {
        perLayer.strokeColor = [UIColor redColor].CGColor;
        tickPath = [UIBezierPath bezierPathWithArcCenter:center radius:[self calculateRadius:startAngel - angle] startAngle:startAngel endAngle:endAngel clockwise:YES];
    } else {
        tickPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.normalRadius startAngle:startAngel endAngle:endAngel clockwise:YES];
    }

    perLayer.path = tickPath.CGPath;
    return perLayer;
}

- (CGFloat)calculateLimitAngle {
    return acosl((pow(self.normalRadius, 2) + pow(self.normalRadius - self.distance, 2) - pow(self.smallRadius, 2)) / (2 * self.normalRadius * (self.normalRadius - self.distance)));
}

- (CGFloat)calculateRadius:(CGFloat)angle {
    return sqrt(powf(self.smallRadius, 2) - powf(self.normalRadius - self.distance, 2) + powf((self.normalRadius - self.distance) * cos(angle), 2)) + (self.normalRadius - self.distance) * cos(angle);
}

//默认参数
- (CGFloat)scaleLineNormalWidth {
    if (!_scaleLineNormalWidth) {
        _scaleLineNormalWidth = 5.0f;
    }
    return _scaleLineNormalWidth;
}

- (CGFloat)smallRadius {
    if (!_smallRadius) {
        _smallRadius = _normalRadius ? _normalRadius / 4 : 40.0f;
    }
    return _smallRadius;
}

- (CGFloat)distance {
    if (!_distance) {
        _distance = _normalRadius ? _normalRadius / 6  : 25.0f;
    }
    return _distance;
}

- (CGFloat)scaleLineBigWidth {
    if (!_scaleLineBigWidth) {
        _scaleLineBigWidth = 10.0f;
    }
    return _scaleLineBigWidth;
}

- (UIColor *)scaleColor {
    if (!_scaleColor) {
        _scaleColor = RGBA(255, 255, 255, 1);
    }
    return _scaleColor;
}

- (CGFloat)normalRadius {
    if (!_normalRadius) {
        _normalRadius = [self maxRadius];
    }
    return _normalRadius;
}

- (CGFloat)maxRadius {
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    if (height > width) {
        return width * 0.5;
    } else {
        return height * 0.5;
    }
}

- (void)setNormalRadius:(CGFloat)radius {
    if (radius > [self maxRadius]) {
        _normalRadius = [self maxRadius];
    } else {
        _normalRadius = radius;
    }
}

- (CGFloat)startAngle {
    if (!_startAngle) {
        _startAngle = M_PI_2 * 3;
    }
    return _startAngle;
}
@end
