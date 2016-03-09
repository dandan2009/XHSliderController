//
//  SliderController.m
//  SliderController
//
//  Created by xiaohui on 16/3/8.
//  Copyright © 2016年 smartisan. All rights reserved.
//

#import "SliderController.h"
#import "TabBarController.h" 

static const CGFloat RIGHT_MARGIN = 70.f;//右边留出的宽度
static const CGFloat TOP_MARGIN = 80.f;//上边距

@interface SliderController ()

@end

@implementation SliderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TabBarController * tc = [self.storyboard instantiateViewControllerWithIdentifier:@"TarBarController"];
    //设置阴影
    tc.view.layer.shadowColor = [UIColor blackColor].CGColor;
    tc.view.layer.shadowOffset = CGSizeMake(-5, 0);
    tc.view.layer.shadowOpacity = 0.2;
    
    [self addChildViewController:tc];
    [self.view addSubview:tc.view];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.childViewControllers[0].view addGestureRecognizer:pan];
}


- (void)panAction:(UIPanGestureRecognizer *)gesture
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat horizontalMaxDisplacment = size.width - RIGHT_MARGIN;// 水平最大位移
    UIView * childView = self.childViewControllers[0].view;
    
    CGAffineTransform transform;
    CGPoint temp;
    
    if (gesture.state == UIGestureRecognizerStateBegan){
        CGPoint point = [gesture translationInView:self.view];
        temp = point;
    }
    
    
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [gesture translationInView:self.view];
        CGFloat pointX = point.x - temp.x;
        
        CGFloat totalPointX = childView.transform.tx + pointX;
        
        if (totalPointX <= horizontalMaxDisplacment && totalPointX >= 0) {
            transform = CGAffineTransformMakeTranslation(totalPointX, 0);
            //线性变化函数，根据向右的视图的tx,计算Y轴变化
            CGFloat scaleY = (size.height - 2 *TOP_MARGIN / horizontalMaxDisplacment * totalPointX) /size.height;
            
            childView.transform = CGAffineTransformScale(transform, 1, scaleY);
            [gesture setTranslation:CGPointZero inView:childView];
        }
    }
    
    
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        transform = CGAffineTransformMakeTranslation(size.width - RIGHT_MARGIN, 0);
        
        [UIView animateWithDuration:0.25f animations:^{
            if (childView.transform.tx > horizontalMaxDisplacment / 2) {
                childView.transform = CGAffineTransformScale(transform, 1,(size.height - 2 * TOP_MARGIN) / size.height);
            }else{
                childView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            }
        }];
        
        transform = CGAffineTransformIdentity;
        temp = CGPointZero;
    }
}

@end
