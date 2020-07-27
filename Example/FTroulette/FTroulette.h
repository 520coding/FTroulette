

#import <UIKit/UIKit.h>

#define RGBA(r, g, b, a)      [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define KAngleToradian(angle) (M_PI / 180.0 * (angle))

NS_ASSUME_NONNULL_BEGIN

@interface FTroulette : UIView

@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat currentValue;

/** 刻度线颜色 */
@property (nonatomic, strong) UIColor *scaleColor;
/** 小刻度线宽 */
@property (nonatomic, assign) CGFloat scaleLineNormalWidth;
/** 大刻度线宽 */
@property (nonatomic, assign) CGFloat scaleLineBigWidth;
/** 刻度线所在圆的半径 */
@property (nonatomic, assign) CGFloat normalRadius;
/** 凸起刻度所在圆的半径 */
@property (nonatomic, assign) CGFloat smallRadius;
/** 调节刻度凸起高度 */
@property (nonatomic, assign) CGFloat distance;
/** 每份分为多少小份 */
@property (nonatomic, assign) NSInteger divideOfUint;
/** 总共分为多少份 */
@property (nonatomic, assign) NSInteger countOfUnit;
/** 起始角 */
@property (nonatomic, assign) CGFloat startAngle;
/**
* 创建轮盘
*/
-(void)createRouletteWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue divideOfUint:(NSInteger)divideOfUint countOfUnit:(NSInteger)countOfUnit;

/**
* 刷新轮盘
*/
-(void)updateView;
@end

NS_ASSUME_NONNULL_END
