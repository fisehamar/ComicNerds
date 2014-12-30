//
//  ComicIssuesTableViewController.m
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import "ComicIssuesTableViewController.h"
#import "SearchComicsTableViewController.h"
#import "issueInfo.h"
#import "ComicDetailViewController.h"

@interface ComicIssuesTableViewController ()
{
    NSArray *feedItems;
}
@property (nonatomic, strong) UIActivityIndicatorView *loading;
@end

@implementation ComicIssuesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(issueModel *)model
{
    if(!_model){
        _model = [[issueModel alloc]init];
    }
    return _model;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    feedItems = [[NSArray alloc] init];
    
    CGRect screensize = [UIScreen mainScreen].bounds;
    _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loading.frame = screensize;
    [_loading startAnimating];
    [_loading setHidden:NO];
    [self.view addSubview:_loading];

    
    // Set this view controller object as the delegate for the issue model object
    self.model.delegate = self;
    
    // Call the download items method of the issue model object
    
    [self.model getItems:self.comic.volumeID];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
//    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [UIColor whiteColor],NSForegroundColorAttributeName,
//                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
//    
//    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)itemsRetrieved:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    feedItems = items;
    [_loading setHidden:YES];
    
    //NSLog(@"%@", items);
    // Reload the table view
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return feedItems.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listcell" forIndexPath:indexPath];
    
    // Configure the cell...
    // Get the location to be shown
    issueInfo *item = feedItems[indexPath.row];
    
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: item.imageIconURL]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    // Get references to labels of cell
    cell.imageView.image = image;
    //cell.textLabel.text = self.comic.volumeName;
    if(item.issueName == (id)[NSNull null])
    {
        cell.textLabel.text = self.comic.volumeName;
    }
    else if(self.comic.volumeName != (id)[NSNull null])
    {
        cell.textLabel.text = item.issueName;
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", item.issueNumber];
    
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toComicsDetail" sender:indexPath];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *index = sender;
    issueInfo *comicIssueInfo = feedItems[index.row];
    
    if ([segue.destinationViewController isKindOfClass:[ComicDetailViewController class]])
    {
        //PlayerModel *pm = [[PlayerModel alloc]init];
        // Get reference to the destination view controller
        ComicDetailViewController *cdvc = [segue destinationViewController];
        
        cdvc.from = @"I";
        
        cdvc.comicIssueInfo = comicIssueInfo;
        cdvc.comicVolumeInfo = self.comic;
    }
}


@end
