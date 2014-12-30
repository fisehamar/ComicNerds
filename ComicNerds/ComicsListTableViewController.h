//
//  ComicsListTableViewController.h
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Defines.h"

@interface ComicsListTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSString *from;
@property (nonatomic, strong) NSMutableArray *myComics;
@property(nonatomic, strong) PFObject *comic;

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;

@end
