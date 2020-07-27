//
//  FTViewController.m
//  FTroulette
//
//  Created by 1085192695@qq.com on 07/27/2020.
//  Copyright (c) 2020 1085192695@qq.com. All rights reserved.
//

#import "FTViewController.h"
#import "FTroulette.h"
@interface FTViewController ()
@property (weak, nonatomic) IBOutlet UISlider *smallRadiusSlider;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;

@property (weak, nonatomic) IBOutlet FTroulette *rouletteView;
@end

@implementation FTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self initSlider];

    [self.rouletteView createRouletteWithMinValue:0 maxValue:100 divideOfUint:20 countOfUnit:10];
}

- (void)initSlider
{
    self.smallRadiusSlider.maximumValue = 100;
    self.smallRadiusSlider.minimumValue = 30;

    self.distanceSlider.maximumValue = 0.5;
    self.distanceSlider.minimumValue = 0;
}

- (IBAction)changeSmallRadius:(UISlider *)sender {
    self.rouletteView.smallRadius = sender.value;
    [self.rouletteView updateView];
}

- (IBAction)changeDivideOfUint:(UISlider *)sender {
    self.rouletteView.divideOfUint = sender.value;
    [self.rouletteView updateView];
}

- (IBAction)changeCountOfUnit:(UISlider *)sender {
    self.rouletteView.countOfUnit = sender.value;
    [self.rouletteView updateView];
}

- (IBAction)changeDistance:(UISlider *)sender {
    self.rouletteView.distance = (1 - sender.value) * self.smallRadiusSlider.value;
    [self.rouletteView updateView];
}

@end
