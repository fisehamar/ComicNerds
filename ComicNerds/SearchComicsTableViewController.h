//
//  SearchComicsTableViewController.h
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import <UIKit/UIKit.h>
#include "comicModel.h"
#import "AppDelegate.h"

@interface SearchComicsTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource, comicModelDelegate>

@property (strong, nonatomic) comicModel *model;

@property (strong, nonatomic) NSString *searchTerm;

- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender;

@end
