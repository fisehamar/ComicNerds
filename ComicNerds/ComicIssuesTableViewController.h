//
//  ComicIssuesTableViewController.h
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import <UIKit/UIKit.h>
#import "issueModel.h"
#import "comicInfo.h"
#import "AppDelegate.h"

@interface ComicIssuesTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource, issueModelDelegate>

@property (nonatomic,strong) NSString *from;

@property (nonatomic, strong) comicInfo *comic;

@property (strong, nonatomic) issueModel *model;

@end



