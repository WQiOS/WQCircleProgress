//
//  Circle.m
//  YKL
//
//  Created by Apple on 15/12/7.
//  Copyright © 2015年 Apple. All rights reserved.
//

#import "XLCircle.h"

/**
 颜色相关
 */
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

static CGFloat endPointMargin = 1.0f;

@interface XLCircle ()<CAAnimationDelegate>
{
    CAShapeLayer* _trackLayer;
    CAShapeLayer* _progressLayer;
    UIView* _endPoint;//在终点位置添加一个点
}
@end

@implementation XLCircle


-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = lineWidth;
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    float centerX = self.bounds.size.width/2.0;
    float centerY = self.bounds.size.height/2.0;
    //半径
    float radius = (self.bounds.size.width - _lineWidth)/2.0;
    
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.8f*M_PI) endAngle:2.8f*M_PI clockwise:YES];
    
    //添加背景圆环
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    //设置填充色
    backLayer.fillColor = [[UIColor clearColor] CGColor];
    //设置描边色
    backLayer.strokeColor = RGB(47,54,69).CGColor;
    backLayer.lineWidth = _lineWidth;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
    
    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    //设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[kUIColorFromRGB(0x3EFFEF) CGColor],(id)[RGB(66, 207, 242) CGColor],(id)[RGB(62, 186, 244) CGColor],nil]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
    
    
    //用于显示结束位置的小点
    _endPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _lineWidth *1.5 - endPointMargin*2,_lineWidth *1.5 - endPointMargin*2)];
    _endPoint.hidden = true;
    _endPoint.backgroundColor = [UIColor blackColor];
    _endPoint.layer.cornerRadius = (_lineWidth *1.5 - endPointMargin*2)/2;
    _endPoint.layer.masksToBounds = YES;
    _endPoint.layer.borderWidth = 6;
    _endPoint.layer.borderColor = kUIColorFromRGB(0x06f0d4).CGColor;
    [self addSubview:_endPoint];
}

-(void)setProgress:(float)progress
{
//    _progress = progress;
    _progressLayer.strokeEnd = progress;
    [self updateEndPoint];
    [_progressLayer removeAllAnimations];
    [self stareLayerAnimation];
}

- (void)stareLayerAnimation{
    CABasicAnimation *anim1 = [CABasicAnimation animation];
    anim1.keyPath = @"transform.rotation";
    anim1.toValue = @(-2* M_PI);
    anim1.repeatCount = 1;
    anim1.duration = 1.0f;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1];
    opacityAnimation.repeatCount = 1;
    opacityAnimation.duration = 1.0f;
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1.0f;
    animationGroup.autoreverses = NO;   //是否重播，原动画的倒播
    animationGroup.repeatCount = 1;//HUGE_VALF;     //HUGE_VALF,源自math.h
    animationGroup.delegate = self;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animationGroup setAnimations:[NSArray arrayWithObjects:anim1, opacityAnimation, nil]];
    [_progressLayer addAnimation:animationGroup forKey:@"animationGroup"];
}
- (void)endPiontStarAnimation{
    // 先缩小
    _endPoint.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        // 放大
        _endPoint.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    
  
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
       [_progressLayer removeAllAnimations];
        _endPoint.hidden = NO;
        [self endPiontStarAnimation];
  
}
//更新小点的位置
-(void)updateEndPoint
{
    //转成弧度
    CGFloat angle = M_PI*2*_progress + 0.5*M_PI;
    float radius = (self.bounds.size.width-_lineWidth)/2.0;
    int index = (angle)/M_PI_2;//用户区分在第几象限内
    float needAngle = (angle +.3*M_PI) - index*M_PI_2;//用于计算正弦/余弦的角度
    float x = 0,y = 0;//用于保存_dotView的frame
    switch (index) {
        case 1:
            NSLog(@"第三象限");
            x = radius - sinf(needAngle)*radius;
            y = radius + cosf(needAngle)*radius;
            
            break;
        case 2:
            NSLog(@"第四象限");
            x = radius - cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
        case 3:
            NSLog(@"第一象限");
            x = radius + sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        case 4:
            NSLog(@"第二象限");
            x = radius + cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
            
        default:
            break;
    }
    
    //更新圆环的frame
    CGRect rect = _endPoint.frame;
    rect.origin.x = x + endPointMargin;
    rect.origin.y = y + endPointMargin;
    _endPoint.frame = rect;
    //移动到最前
    [self bringSubviewToFront:_endPoint];
    if (_progress == 0 || _progress == 1) {
        _endPoint.hidden = true;
    }
}

@end
