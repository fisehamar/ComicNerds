//
//  ComicsListTableViewController.m
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import "ComicsListTableViewController.h"
#import "ComicDetailViewController.h"
#import "EditComicViewController.h"

@interface ComicsListTableViewController ()
//@property (nonatomic, strong) UIActivityIndicatorView *loading;
@end

@implementation ComicsListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray *)myComics
{
    if (!_myComics)
    {
        _myComics = [[NSMutableArray alloc]init];
    }
    return _myComics;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:USERSCOMICSCLASS];

    [query whereKey:USERSCOMICSUSER equalTo:[PFUser currentUser]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.myComics addObjectsFromArray:objects];
         [self.tableView reloadData];
     }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.myComics count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comicsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *comic = [self.myComics objectAtIndex:indexPath.row];
    
    cell.textLabel.text = comic[USERSCOMICSTITLENAME];
    cell.detailTextLabel.text = comic[USERSCOMICSPUBLISHER];
    
    PFFile *theImage = [comic objectForKey:USERSCOMICSCOVERIMAGE];
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    cell.imageView.image = image;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.from isEqualToString:@"Edit"])
    {
        [self performSegueWithIdentifier:@"toEditComic" sender:self];
    }
    else if([self.from isEqualToString:@"List"])
    {
        [self performSegueWithIdentifier:@"toComicsDetail" sender:self];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        unsigned long index = indexPath.row;
        
        PFObject *comic = [self.myComics objectAtIndex:index];
        
        [self.myComics removeObjectAtIndex:index];
        
        [comic deleteInBackground];
        
        [self.tableView setEditing:NO animated:YES];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)reorderCells
{
    if (self.tableView.editing == YES)[self.tableView setEditing:NO animated:YES];
    else [self.tableView setEditing:YES animated:YES];
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender
{
    [self reorderCells];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    _comic = _myComics[index.row];
    if ([[segue identifier] isEqualToString:@"toComicsDetail"])
    {
        if ([segue.destinationViewController isKindOfClass:[ComicDetailViewController class]])
        {
            // Get reference to the destination view controller
            ComicDetailViewController *cdvc = [segue destinationViewController];
            
            cdvc.from = @"L";
            // Get index of selected row
            cdvc.comic = _comic;
            
        }
    }
    else if ([[segue identifier] isEqualToString:@"toEditComic"])
    {
        if ([segue.destinationViewController isKindOfClass:[EditComicViewController class]])
        {
            // Get reference to the destination view controller
            EditComicViewController *ecvc = [segue destinationViewController];
            
            ecvc.comic = _comic;
            
        }
    }
}
@end
