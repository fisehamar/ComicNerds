//
//  ActionView.h
//  ComicNerds
//
//  Created by Joffrey Mann on 12/29/14.
//  Copyright (c) 2014 Nutech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol ActionViewDelegate <NSObject>

-(void)dismissActions;
-(void)showInView:(UIView *)view;
-(void)logout;

@end

@interface ActionView : UIView

@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *noButton;
@property (weak, nonatomic) id <ActionViewDelegate> delegate;
@property (assign, nonatomic) BOOL showing;

-(void)dismissActions;
-(void)showInView:(UIView *)view;
-(void)logoutUser;

@end
