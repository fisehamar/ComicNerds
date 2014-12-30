//
//  ComicDetailViewController.m
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import "ComicDetailViewController.h"
#import "creditsInfo.h"

@interface ComicDetailViewController ()
{
    NSArray *feedItems;
    PFObject *comic;
}

@end

@implementation NSString(strip)

-(NSString *) stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end

@implementation ComicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(creditsModel *)model
{
    if(!_model){
        _model = [[creditsModel alloc]init];
    }
    return _model;
}

-(ComicsListTableViewController *)tableController
{
    if(!_tableController){
        _tableController = [[ComicsListTableViewController alloc]init];
    }
    return _tableController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    scroller = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scroller.contentSize = CGSizeMake(self.view.frame.size.width, 884);
    scroller.delegate = self;
    
    _titleHeadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 279, 277, 21)];
    _titleHeadingLabel.text = @"Title Name";
    _titleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 301, self.view.frame.size.width, 40)];
    _titleNameLabel.numberOfLines = 0;
    _authorHeadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 364, 277, 21)];
    _authorHeadingLabel.text = @"Author";
    _artistHeadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 430, 277, 21)];
    _artistHeadingLabel.text = @"Artist";
    _authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 386, 207, 21)];
    _artistLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 452, 207, 21)];
    _publisherHeadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 497, 277, 21)];
    _publisherHeadingLabel.text = @"Publisher";
    _publisherLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 519, 289, 21)];
    _issueNumberHeadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 565, 289, 21)];
    _issueNumberHeadingLabel.text = @"Issue Number";
    _issueNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 587, 289, 21)];
    _publicationHeadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 632, 289, 21)];
    _publicationDateNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 654, 289, 21)];
    _commentLabel = [[UITextView alloc]initWithFrame:CGRectMake(5, 700, 207, 100)];
    self.comicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    if ([self.from isEqualToString:@"L"])
    {
        [self.addButtonProperty setEnabled:NO];
        
        self.titleNameLabel.text = self.comic[USERSCOMICSTITLENAME];
        self.publisherLabel.text = self.comic[USERSCOMICSPUBLISHER];
        self.issueNumLabel.text = self.comic[USERSCOMICSISSUENUM];
        self.publicationDateNumLabel.text = self.comic[USERSCOMICSPUBLICATIONDATE];
        self.commentLabel.text = self.comic[USERSCOMICSCOMMENTS];
        self.authorLabel.text = self.comic[USERSCOMICSAUTHOR];
        self.artistLabel.text = self.comic[USERSCOMICSARTIST];
        
        PFFile *theImage = [self.comic objectForKey:USERSCOMICSCOVERIMAGE];
        NSData *imageData = [theImage getData];
        UIImage *image = [UIImage imageWithData:imageData];
        self.comicImageView.image = image;
    }
    else if ([self.from isEqualToString:@"I"])
    {
        feedItems = [[NSArray alloc] init];
        
        // Set this view controller object as the delegate for the issue model object
        self.model.delegate = self;
        
        [self.addButtonProperty setEnabled:YES];
        
        [self.model getItems:self.comicIssueInfo.issueAPIURL];
        
        if(self.comicIssueInfo.issueName == (id)[NSNull null])
        {
            self.titleNameLabel.text = [NSString stringWithFormat:@"%@",self.comicVolumeInfo.volumeName];
        }
        else if(self.comicVolumeInfo.volumeName != (id)[NSNull null])
        {
            self.titleNameLabel.text = [NSString stringWithFormat:@"%@", self.comicIssueInfo.issueName];
        }
        
        if(self.comicVolumeInfo.publisherName == (id)[NSNull null])
        {
            self.publisherLabel.text = @"No publisher listed for this comic";
        }
        else if(self.comicVolumeInfo.publisherName != (id)[NSNull null])
        {
            self.publisherLabel.text = [NSString stringWithFormat:@"%@",self.comicVolumeInfo.publisherName];
        }
        
        self.issueNumLabel.text = [NSString stringWithFormat:@"%@",self.comicIssueInfo.issueNumber];
        
        if(self.comicIssueInfo.coverDate == (id)[NSNull null])
        {
            self.publicationDateNumLabel.text = @"No publication date for this comic";
        }
        else if(self.comicIssueInfo.coverDate != (id)[NSNull null])
        {
            self.publicationDateNumLabel.text = self.comicIssueInfo.coverDate;
        }
        
        if(self.comicIssueInfo.comicDescription == (id)[NSNull null])
        {
            self.commentLabel.text = @"No comments for this comic";
        }
        else if(self.comicIssueInfo.comicDescription != (id)[NSNull null])
        {
            self.commentLabel.text = [NSString stringWithFormat:@"Comments: %@",[self.comicIssueInfo.comicDescription stringByStrippingHTML]];
        }
        
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: self.comicIssueInfo.imageMediumURL]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        
        self.comicImageView.image = image;
        
        PFQuery *query = [PFQuery queryWithClassName:USERSCOMICSCLASS];
        
        [query whereKey:USERSCOMICSUSER equalTo:[PFUser currentUser]];
    }
    
    [scroller addSubview:_publisherLabel];
    [scroller addSubview:_publicationDateNumLabel];
    [scroller addSubview:_titleHeadingLabel];
    [scroller addSubview:_titleNameLabel];
    [scroller addSubview:_issueNumLabel];
    [scroller addSubview:_artistHeadingLabel];
    [scroller addSubview:_artistLabel];
    [scroller addSubview:_commentLabel];
    [scroller addSubview:_authorHeadingLabel];
    [scroller addSubview:_authorLabel];
    [scroller addSubview:_publisherHeadingLabel];
    [scroller addSubview:_issueNumberHeadingLabel];
    [scroller addSubview:self.comicImageView];
    [self.view addSubview:scroller];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"Scrolling");
}

-(void)itemsRetrieved:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    feedItems = items;
    
    //NSLog(@"Count %lu", (unsigned long)feedItems.count);
    
    NSMutableString *authors = [NSMutableString new];
    NSMutableString *artist = [NSMutableString new];
    //
    for (creditsInfo * credit in feedItems)
    {
        if(credit.author == (id)[NSNull null])
        {
            [authors appendString:@"No author listed for this comic"];
        }
        else if(credit.author != (id)[NSNull null])
        {
            //self.publisherLabel.text = self.comicVolumeInfo.publisherName;
            [authors appendString:[NSString stringWithFormat:@"%@\n",credit.author]];
            NSLog(@"%@",credit.author);
        }
        
        if(credit.artist == (id)[NSNull null])
        {
            artist = [@"No artist listed for this comic" mutableCopy];
        }
        else if(credit.artist != (id)[NSNull null])
        {
            [artist appendString:[NSString stringWithFormat:@"%@\n", credit.artist]];
            NSLog(@"%@",credit.artist);
        }
    }
    self.authorLabel.text = authors;
    self.artistLabel.text = artist;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            
            // Create a PFObject around a PFFile and associate it with the current user
            comic = [PFObject objectWithClassName:USERSCOMICSCLASS];
            [comic setObject:imageFile forKey:USERSCOMICSCOVERIMAGE];
            
            [comic setObject:self.titleNameLabel.text forKey:USERSCOMICSTITLENAME];
            [comic setObject:self.authorLabel.text forKey:USERSCOMICSAUTHOR];
            [comic setObject:self.artistLabel.text forKey:USERSCOMICSARTIST];
            [comic setObject:self.publisherLabel.text forKey:USERSCOMICSPUBLISHER];
            [comic setObject:self.issueNumLabel.text forKey:USERSCOMICSISSUENUM];
            [comic setObject:self.publicationDateNumLabel.text forKey:USERSCOMICSPUBLICATIONDATE];
            [comic setObject:self.commentLabel.text forKey:USERSCOMICSCOMMENTS];
            [comic setObject:[NSString stringWithFormat:@"%@",self.comicIssueInfo.issueID] forKey:USERSCOMICSISSUEID];

            
            PFRelation *relation = [comic relationforKey:USERSCOMICSUSER];
            [relation addObject:[PFUser currentUser]];
            
             //Set the access control list to current user for security purposes
//            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            [comic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //[self refresh:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else
        {
            //[HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender
{
    self.comic= [PFObject objectWithClassName:USERSCOMICSCLASS];
    
    NSData *imageData = UIImageJPEGRepresentation(self.comicImageView.image, 0.05f);
    [self uploadImage:imageData];
    
//    PFRelation *relation = [comic relationforKey:USERSCOMICSUSER];
//    [relation addObject:[PFUser currentUser]];
//    [self.comic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
}
@end
