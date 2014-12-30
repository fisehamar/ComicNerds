//
//  ActionView.m
//  ComicNerds
//
//  Created by Joffrey Mann on 12/29/14.
//  Copyright (c) 2014 Nutech. All rights reserved.
//

#import "ActionView.h"

@implementation ActionView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"slateGrayAS.jpg"]];
    imgView.frame = self.bounds;
    [self addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    titleLabel.text = @"Are you sure you want to log out?";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        
    CGFloat actionArea = self.bounds.size.height-40;
    CGFloat buttonHeight = actionArea/2;
    self.yesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.yesButton addTarget:self
                           action:@selector(logoutUser)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.yesButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    self.yesButton.frame = CGRectMake(0, 40, self.bounds.size.width, buttonHeight);
        NSLog(@"%f", actionArea);
        
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = _yesButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor colorWithRed:201.0f / 255.0f green:23.0f / 255.0f blue:52.0f / 255.0f alpha:1.0f] CGColor],
                            (id)[[UIColor colorWithRed:101.0f / 255.0f green:11.0f / 255.0f blue:25.0f / 255.0f alpha:1.0f] CGColor],
                            nil];
    
    self.noButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.noButton addTarget:self
                       action:@selector(dismissActions)
             forControlEvents:UIControlEventTouchUpInside];
    [self.noButton setTitle:@"No" forState:UIControlStateNormal];
    [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.noButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        self.noButton.titleLabel.alpha = 0.8;
    self.noButton.frame = CGRectMake(0, 40+buttonHeight, self.bounds.size.width, buttonHeight);
        
    CAGradientLayer *btnGradientTwo = [CAGradientLayer layer];
    btnGradientTwo.frame = _noButton.bounds;
    btnGradientTwo.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:23.0f / 255.0f green:201.0f / 255.0f blue:52.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:11.0f / 255.0f green:101.0f / 255.0f blue:25.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
        
    [_yesButton.layer insertSublayer:btnGradient atIndex:0];
    [_noButton.layer insertSublayer:btnGradientTwo atIndex:0];
    [self addSubview:_yesButton];
    [self addSubview:_noButton];
    [self addSubview:titleLabel];
        //_showing = YES;
    }
    return self;
}

-(void)logoutUser
{
    [self.delegate logout];
}

-(void)dismissActions
{
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.alpha = 0;
                     }completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
    //_showing = NO;
}

-(void)showInView:(UIView *)view
{
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.5];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[self layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    [view addSubview:self];
    //_showing = YES;
}
@end
