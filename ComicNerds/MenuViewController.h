//
//  MenuViewController.h
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/14/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//
#import <Parse/Parse.h>
#import "ActionView.h"

@interface MenuViewController : UIViewController<NSURLConnectionDataDelegate,UIActionSheetDelegate, ActionViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addLabel;
@property (strong, nonatomic) IBOutlet UILabel *editLabel;
@property (strong, nonatomic) IBOutlet UILabel *listLabel;
@property (strong, nonatomic) IBOutlet UILabel *searchLabel;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *listButton;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) UIActionSheet *logoutAction;
@property (strong, nonatomic) ActionView *actionView;

- (IBAction)logOutButtonTapAction:(id)sender;
- (IBAction)searchButtonPressed:(UIButton *)sender;

@end
