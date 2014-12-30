//
//  SearchComicsTableViewController.m
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import "SearchComicsTableViewController.h"
#import "ComicIssuesTableViewController.h"
#import "comicInfo.h"

@interface SearchComicsTableViewController ()
{
    NSArray *feedItems;

}
@property (nonatomic, strong) UIActivityIndicatorView *loading;
@end

@implementation SearchComicsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(comicModel *)model
{
    if(!_model){
        _model = [[comicModel alloc]init];
    }
    return _model;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    CGRect screensize = [UIScreen mainScreen].bounds;
//    _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _loading.frame = screensize;
//    [_loading startAnimating];
//    [_loading setHidden:NO];
//    [self.view addSubview:_loading];
    
    feedItems = [[NSArray alloc] init];
    
    // Create new HomeModel object and assign it to _homeModel variable
    //self.mod = [[PlayerModel alloc] init];
    [self showSearchAlert];
}

-(void)reloadSearch
{
    CGRect screensize = [UIScreen mainScreen].bounds;
    _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loading.frame = screensize;
    [_loading startAnimating];
    [_loading setHidden:NO];
    [self.view addSubview:_loading];
    
    feedItems = [[NSArray alloc] init];
    // Set this view controller object as the delegate for the comic model object
    self.model.delegate = self;
    
    // Call the download items method of the comic model object
    
    [self.model getItems:[self.searchTerm stringByReplacingOccurrencesOfString:@" " withString: @"_"]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)itemsRetrieved:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    feedItems = items;
    
    [_loading setHidden:YES];
    
    if ([feedItems count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No results" message:[NSString stringWithFormat: @"We have not found any results corresponding to the search term %@", self.searchTerm] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    //NSLog(@"%@", items);
    // Reload the table view
    [self.tableView reloadData];
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comicViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    // Get the location to be shown
    comicInfo *item = feedItems[indexPath.row];
    
    cell.textLabel.text = item.volumeName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",item.issueCount];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toIssueList" sender:indexPath];
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
- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender
{
    [self showSearchAlert];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField =  [alertView textFieldAtIndex: 0];
    // NO = 0, YES = 1
    if(buttonIndex == 0)
    {
    }
    else
    {
        if (textField.text && textField.text.length > 0)
        {
            NSLog(@"textfield = %@", textField.text);
            self.searchTerm = [textField.text uppercaseString];
            [self reloadSearch];
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

-(void)showSearchAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search"
                                                    message:@"Please enter a search term"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Go",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index = sender;
    comicInfo *comic = feedItems[index.row];
    if ([[segue identifier] isEqualToString:@"toIssueList"])
    {
        if ([segue.destinationViewController isKindOfClass:[ComicIssuesTableViewController class]])
        {
            ComicIssuesTableViewController *cltvc = [segue destinationViewController];
            
            cltvc.comic = comic;
        }
    }
}

@end
