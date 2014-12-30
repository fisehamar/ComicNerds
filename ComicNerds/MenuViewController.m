//
//  MenuViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/14/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "MenuViewController.h"
#import "ComicsListTableViewController.h"
#import "SearchComicsTableViewController.h"
#import <PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MTConstants.h"
#import "MTLoginViewController.h"

@implementation MenuViewController


#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        self.welcomeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [[PFUser currentUser] username]];
        NSLog(@"%@", [PFUser currentUser][@"FirstName" ]);
    } else {
        self.welcomeLabel.text = NSLocalizedString(@"Not logged in", nil);
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    _actionView.showing = NO;
    [self applyGradients];
    
    self.welcomeLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:29.0/255.0 blue:75.0/255.0 alpha:1];
    
    self.addLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:29.0/255.0 blue:75.0/255.0 alpha:1];
    
    self.editLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:29.0/255.0 blue:75.0/255.0 alpha:1];
    
    self.listLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:29.0/255.0 blue:75.0/255.0 alpha:1];
    
    self.searchLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:29.0/255.0 blue:75.0/255.0 alpha:1];
    
    if (![[PFUser currentUser] valueForKey:@"profile"])
    {
        FBRequest *request = [FBRequest requestForMe];
        
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            
            if (!error){
                NSDictionary *userDictionary = (NSDictionary *)result;
                
                //create URL
                NSString *facebookID = userDictionary[@"id"];
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",facebookID]];
                
                NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:8];
                if (userDictionary[@"name"]){
                    userProfile[kCCUserProfileNameKey] = userDictionary[@"name"];
                }
                if (userDictionary[@"first_name"]){
                    userProfile[kCCUserProfileFirstNameKey] = userDictionary[@"first_name"];
                }
                if (userDictionary[@"location"][@"name"]){
                    userProfile[kCCUserProfileLocationKey] = userDictionary[@"location"][@"name"];
                }
                if (userDictionary[@"gender"]){
                    userProfile[kCCUserProfileGenderKey] = userDictionary[@"gender"];
                }
                if (userDictionary[@"birthday"])
                {
                    userProfile[kCCUserProfileBirthdayKey] = userDictionary[@"birthday"];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateStyle:NSDateFormatterShortStyle];
                    NSDate *date = [formatter dateFromString:userDictionary[@"birthday"]];
                    NSDate *now = [NSDate date];
                    NSTimeInterval seconds = [now timeIntervalSinceDate:date];
                    int age = seconds / 31536000;
                    userProfile[kCCUserProfileAgeKey] = @(age);
                }
                
                if (userDictionary[@"interested_in"]){
                    userProfile[kCCUserProfileInterestedInKey] = userDictionary[@"interested_in"];
                }
                if (userDictionary[@"relationship_status"]){
                    userProfile[kCCUserProfileRelationshipStatusKey] = userDictionary[@"relationship_status"];
                }
                if ([pictureURL absoluteString]){
                    userProfile[kCCUserProfilePictureURL] = [pictureURL absoluteString];
                }
                
                //[[PFUser currentUser]setObject:@YES forKey:USERYEARSEARCH];
                [[PFUser currentUser] setObject:userProfile forKey:kCCUserProfileKey];
                [[PFUser currentUser] saveInBackground];
                self.navigationItem.title = @"Welcome";
                [self requestImage];
            }
            else {
                NSLog(@"Error in FB request %@", error);
            }
        }];
    }
    NSDictionary *profile = [PFUser currentUser][@"profile"];
    self.navigationItem.title = [NSString stringWithFormat:@"Welcome %@",profile[@"firstName"]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Arial" size:17.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    CGRect navBounds = CGRectMake(0, 0, 320, 64);
    self.navigationController.navigationBar.bounds = navBounds;
    
    CALayer * bgGradientLayer = [self gradientBGLayerForBounds:navBounds];
    UIGraphicsBeginImageContext(bgGradientLayer.bounds.size);
    [bgGradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * bgAsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    if (bgAsImage != nil)
    {
        [[UINavigationBar appearance] setBackgroundImage:bgAsImage
                                           forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        NSLog(@"Failded to create gradient bg image, user will see standard tint color gradient.");
    }
    
    PFFile *theImage = [[PFUser currentUser] objectForKey:@"UserImage"];
    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        self.imgView.image = image;
        self.imgView.layer.cornerRadius = 85;
        self.imgView.clipsToBounds = YES;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)requestImage
{
    PFQuery *query = [PFQuery queryWithClassName:kCCPhotoClassKey];
    [query whereKey:kCCPhotoUserKey equalTo:[PFUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0)
        {
            PFUser *user = [PFUser currentUser];
            
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *profilePictureURL = [NSURL URLWithString:user[kCCUserProfileKey][kCCUserProfilePictureURL]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            if (!urlConnection){
                NSLog(@"Failed to Download Picture");
            }
        }
    }];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"connection did recieve data");
    [self.imageData appendData:data];
    [self uploadImage:self.imageData];
}

-(void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"ProfileImage.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            // Create a PFObject around a PFFile and associate it with the current user
            [[PFUser currentUser] setObject:imageFile forKey:@"UserImage"];
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error)
                {
                    //[self refresh:nil];
                }
                else
                {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    self.profileImage = [UIImage imageWithData:self.imageData];
}

-(void)applyGradients
{
    CALayer *buttonLayerOne = [self.addButton layer];
    [buttonLayerOne setMasksToBounds:YES];
    [buttonLayerOne setCornerRadius:5.0f];
    
    CALayer *buttonLayerTwo = [self.editButton layer];
    [buttonLayerTwo setMasksToBounds:YES];
    [buttonLayerTwo setCornerRadius:5.0f];
    
    CALayer *buttonLayerThree = [self.listButton layer];
    [buttonLayerThree setMasksToBounds:YES];
    [buttonLayerThree setCornerRadius:5.0f];
    
    CALayer *buttonLayerFour = [self.searchButton layer];
    [buttonLayerFour setMasksToBounds:YES];
    [buttonLayerFour setCornerRadius:5.0f];
    
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = _addButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:134.0f / 255.0f green:23.0f / 255.0f blue:152.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:67.0f / 255.0f green:11.0f / 255.0f blue:76.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    
    CAGradientLayer *btnGradientTwo = [CAGradientLayer layer];
    btnGradientTwo.frame = _editButton.bounds;
    btnGradientTwo.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:134.0f / 255.0f green:23.0f / 255.0f blue:152.0f / 255.0f alpha:1.0f] CGColor],
                             (id)[[UIColor colorWithRed:67.0f / 255.0f green:11.0f / 255.0f blue:76.0f / 255.0f alpha:1.0f] CGColor],
                             nil];
    
    CAGradientLayer *btnGradientThree = [CAGradientLayer layer];
    btnGradientThree.frame = _listButton.bounds;
    btnGradientThree.colors = [NSArray arrayWithObjects:
                               (id)[[UIColor colorWithRed:134.0f / 255.0f green:23.0f / 255.0f blue:152.0f / 255.0f alpha:1.0f] CGColor],
                               (id)[[UIColor colorWithRed:67.0f / 255.0f green:11.0f / 255.0f blue:76.0f / 255.0f alpha:1.0f] CGColor],
                               nil];

    
    CAGradientLayer *btnGradientFour = [CAGradientLayer layer];
    btnGradientFour.frame = _searchButton.bounds;
    btnGradientFour.colors = [NSArray arrayWithObjects:
                              (id)[[UIColor colorWithRed:134.0f / 255.0f green:23.0f / 255.0f blue:152.0f / 255.0f alpha:1.0f] CGColor],
                              (id)[[UIColor colorWithRed:67.0f / 255.0f green:11.0f / 255.0f blue:76.0f / 255.0f alpha:1.0f] CGColor],
                              nil];
    
    [_addButton.layer insertSublayer:btnGradient atIndex:0];
    [_editButton.layer insertSublayer:btnGradientTwo atIndex:1];
    [_listButton.layer insertSublayer:btnGradientThree atIndex:2];
    [_searchButton.layer insertSublayer:btnGradientFour atIndex:3];
}

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex == 0)
//    {
//        [PFUser logOut];
//        MTLoginViewController *lController = [[MTLoginViewController alloc]init];
//        lController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
//        [self presentViewController:lController animated:YES completion:nil];
//    }
//}

-(void)logout
{
    [PFUser logOut];
    MTLoginViewController *lController = [[MTLoginViewController alloc]init];
    lController = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self presentViewController:lController animated:YES completion:nil];
}

-(void)isShowing
{
    if(_actionView.showing == NO)
    {
        _actionView = [[ActionView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*2/3, self.view.frame.size.width, self.view.frame.size.height/3)];
        _actionView.delegate = self;
        [_actionView showInView:self.view];
        _actionView.showing = YES;
    }
    else
    {
        _actionView.showing = NO;
        [_actionView dismissActions];
    }
}

#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    //_actionView.showing = YES;
    [self isShowing];
}

- (IBAction)searchButtonPressed:(UIButton *)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search"
//                                                    message:@"Please enter a search term"
//                                                   delegate:self
//                                          cancelButtonTitle:@"Cancel"
//                                          otherButtonTitles:@"Go",nil];
//    
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField =  [alertView textFieldAtIndex:0];
    // NO = 0, YES = 1
    if(buttonIndex == 0)
    {
    }
    else
    {
        if (textField.text && textField.text.length > 0)
        {
            NSLog(@"textfield = %@", textField.text);
            self.searchTerm = textField.text;
            //[self performSegueWithIdentifier:@"toSearch" sender:self];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You must enter a search term"
                                                            message:@"In order to complete the search you must enter a comic to search for in the text box!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Go",nil];
            
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
        }
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toEditTableView"])
    {
        if ([segue.destinationViewController isKindOfClass:[ComicsListTableViewController class]])
        {
            ComicsListTableViewController *cltvc = [segue destinationViewController];
            cltvc.from = @"Edit";
        }
    }
    else if ([[segue identifier] isEqualToString:@"toComicsList"])
    {
        if ([segue.destinationViewController isKindOfClass:[ComicsListTableViewController class]])
        {
            ComicsListTableViewController *cltvc = [segue destinationViewController];
            cltvc.from = @"List";
        }
    }
    
    if ([segue.destinationViewController isKindOfClass:[SearchComicsTableViewController class]])
    {
        SearchComicsTableViewController *searchController = segue.destinationViewController;
        
        searchController.searchTerm =  self.searchTerm;
    }
}

- (CALayer *)gradientBGLayerForBounds:(CGRect)bounds
{
    CAGradientLayer * gradientBG = [CAGradientLayer layer];
    gradientBG.frame = bounds;
    gradientBG.colors = [NSArray arrayWithObjects:
                         (id)[[UIColor colorWithRed:134.0f / 255.0f green:23.0f / 255.0f blue:152.0f / 255.0f alpha:1.0f] CGColor],
                         (id)[[UIColor colorWithRed:67.0f / 255.0f green:11.0f / 255.0f blue:76.0f / 255.0f alpha:1.0f] CGColor],
                         nil];
    return gradientBG;
}

@end
