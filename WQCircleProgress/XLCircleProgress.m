//
//  CircleView.m
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XLCircleProgress.h"
#import "XLCircle.h"
/**
 颜色相关
 */
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface XLCircleProgress ()

@property (nonatomic,strong) XLCircle *circle;
@property (nonatomic,strong) UIImageView *backgroundIMV;
@property (nonatomic,strong) UILabel *percentLabel;
@property (nonatomic,strong) UILabel *downPercentLabel;

@end

@implementation XLCircleProgress

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.backgroundIMV];
    [self addSubview:self.percentLabel];
    [self addSubview:self.downPercentLabel];
    [self addSubview:self.circle];
}

#pragma mark Setter方法
- (void)setProgress:(float)progress {
    self.circle.progress = progress;
    NSString *progressStr = [NSString stringWithFormat:@"%.f",ceil(progress * 100)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%%",progressStr]];
    NSRange Range2 = NSMakeRange(progressStr.length, 1);
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:Range2];
    [self.percentLabel setAttributedText:str];
}

- (UIImageView *)backgroundIMV {
    if (!_backgroundIMV) {
        _backgroundIMV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, self.bounds.size.width - 24, self.bounds.size.width - 24)];
    }
    return _backgroundIMV;
}

- (UILabel *)percentLabel {
    if (!_percentLabel) {
        _percentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _percentLabel.textColor = kUIColorFromRGB(0x06f0d4);
        _percentLabel.textAlignment = NSTextAlignmentCenter;
        _percentLabel.font = [UIFont boldSystemFontOfSize:50];
    }
    return _percentLabel;
}

- (UILabel *)downPercentLabel {
    if (!_downPercentLabel) {
        _downPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 30, self.bounds.size.width/2 + 30, 60, 12)];
        _downPercentLabel.textColor = kUIColorFromRGB(0xffffff);
        _downPercentLabel.textAlignment = NSTextAlignmentCenter;
        _downPercentLabel.font = [UIFont systemFontOfSize:12];
        _downPercentLabel.alpha = 0.6;
        _downPercentLabel.text = @"完成率";
    }
    return _downPercentLabel;
}

- (XLCircle *)circle {
    if (!_circle) {
        _circle = [[XLCircle alloc] initWithFrame:self.bounds lineWidth:10];
        _circle.backgroundColor = [UIColor clearColor];
    }
    return _circle;
}
@end
