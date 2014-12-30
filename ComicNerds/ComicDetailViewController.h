//
//  ComicDetailViewController.h
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import <UIKit/UIKit.h>
#import "comicInfo.h"
#import "issueInfo.h"
#import "creditsModel.h"
#import "ComicsListTableViewController.h"
#import <Parse/Parse.h>


@interface ComicDetailViewController : UIViewController<creditsModelDelegate, UIScrollViewDelegate>
{
    UIScrollView *scroller;
}

@property (strong, nonatomic) creditsModel *model;

@property(nonatomic, strong) PFObject *comic;
@property (strong, nonatomic) UILabel *titleNameLabel;
@property (strong, nonatomic) UILabel *titleHeadingLabel;
@property (strong, nonatomic) UILabel *issueNumberHeadingLabel;
@property (strong, nonatomic) UILabel *issueNumLabel;
@property (strong, nonatomic) UILabel *publicationHeadingLabel;
@property (strong, nonatomic) UILabel *publicationDateNumLabel;
@property (strong, nonatomic) UITextView *commentLabel;
@property (strong, nonatomic) UILabel *publisherHeadingLabel;
@property (strong, nonatomic) UILabel *publisherLabel;
@property (strong, nonatomic) UILabel *authorHeadingLabel;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *artistHeadingLabel;
@property (strong, nonatomic) UILabel *artistLabel;

@property (strong,nonatomic) NSString *from;

@property (nonatomic, strong) comicInfo *comicVolumeInfo;

@property (nonatomic, strong) issueInfo *comicIssueInfo;

@property (strong, nonatomic) ComicsListTableViewController *tableController;

@property (strong, nonatomic) UIImageView *comicImageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButtonProperty;

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender;

@end
