//
//  AddComicViewController.m
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import "AddComicViewController.h"
#import "SearchComicsTableViewController.h"

@interface AddComicViewController ()
{
    PFObject *comic;
    UIImage *chosenImage;
}

@end

@implementation AddComicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    comic= [PFObject objectWithClassName:USERSCOMICSCLASS];
    
    self.titleNameTextField.delegate = self;
    self.authorTextField.delegate = self;
    self.artistTextField.delegate = self;
    self.publisherTextField.delegate = self;
    self.issueNumTextField.delegate = self;
    //self.volumeNumTextField.delegate = self;
    self.publicationDateTextField.delegate = self;
    self.commentsTextField.delegate = self;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self applyGradients];
}

-(void)viewWillAppear:(BOOL)animated
{
    _comicImage.image = chosenImage;
}

-(void)applyGradients
{
    CALayer *buttonLayerOne = [self.addButton layer];
    [buttonLayerOne setMasksToBounds:YES];
    [buttonLayerOne setCornerRadius:5.0f];
    
    CALayer *buttonLayerTwo = [self.takePictureButton layer];
    [buttonLayerTwo setMasksToBounds:YES];
    [buttonLayerTwo setCornerRadius:5.0f];
    
    CALayer *buttonLayerThree = [self.selectPhotoButton layer];
    [buttonLayerThree setMasksToBounds:YES];
    [buttonLayerThree setCornerRadius:5.0f];
    
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = _addButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:134.0f / 255.0f green:23.0f / 255.0f blue:152.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:67.0f / 255.0f green:11.0f / 255.0f blue:76.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    
    CAGradientLayer *btnGradientTwo = [CAGradientLayer layer];
    btnGradientTwo.frame = _takePictureButton.bounds;
    btnGradientTwo.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:134.0f / 255.0f green:23.0f / 255.0f blue:152.0f / 255.0f alpha:1.0f] CGColor],
                             (id)[[UIColor colorWithRed:67.0f / 255.0f green:11.0f / 255.0f blue:76.0f / 255.0f alpha:1.0f] CGColor],
                             nil];
    
    CAGradientLayer *btnGradientThree = [CAGradientLayer layer];
    btnGradientThree.frame = _selectPhotoButton.bounds;
    btnGradientThree.colors = [NSArray arrayWithObjects:
                               (id)[[UIColor colorWithRed:134.0f / 255.0f green:23.0f / 255.0f blue:152.0f / 255.0f alpha:1.0f] CGColor],
                               (id)[[UIColor colorWithRed:67.0f / 255.0f green:11.0f / 255.0f blue:76.0f / 255.0f alpha:1.0f] CGColor],
                               nil];
    
    [_addButton.layer insertSublayer:btnGradient atIndex:0];
    [_takePictureButton.layer insertSublayer:btnGradientTwo atIndex:1];
    [_selectPhotoButton.layer insertSublayer:btnGradientThree atIndex:2];
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

- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search"
                                                    message:@"Please enter a search term"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Go",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
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
            self.searchTerm = textField.text;
            [self performSegueWithIdentifier:@"toSearch" sender:self];
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

- (IBAction)addComicButton:(id)sender
{
    if([_titleNameTextField.text length] > 0 && [_authorTextField.text length] > 0 && [_artistTextField.text length] > 0 && [_publisherTextField.text length] > 0 && [_publicationDateTextField.text length] > 0 && [_issueNumTextField.text length] > 0 && [_commentsTextField.text length] > 0 && _comicImage.image != nil)
    {
        NSData *imageData = UIImageJPEGRepresentation(self.comicImage.image, 0.05f);
        [self uploadImage:imageData];
    }
    
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must provide all required information, including a photo before adding a comic." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)takePictureButton:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPictureButton:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *resizedImage = [self resizeImage:info[UIImagePickerControllerEditedImage]];
    chosenImage = resizedImage;
    //self.comicImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}

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
            [comic setObject:self.titleNameTextField.text forKey:USERSCOMICSTITLENAME];
            [comic setObject:self.authorTextField.text forKey:USERSCOMICSAUTHOR];
            [comic setObject:self.artistTextField.text forKey:USERSCOMICSARTIST];
            [comic setObject:self.publisherTextField.text forKey:USERSCOMICSPUBLISHER];
            [comic setObject:self.issueNumTextField.text forKey:USERSCOMICSISSUENUM];
            //[comic setObject:self.volumeNumTextField.text forKey:USERSCOMICSVOLUMENUM];
            [comic setObject:self.publicationDateTextField.text forKey:USERSCOMICSPUBLICATIONDATE];
            [comic setObject:self.commentsTextField.text forKey:USERSCOMICSCOMMENTS];
            PFRelation *relation = [comic relationForKey:USERSCOMICSUSER];
            [relation addObject:[PFUser currentUser]];

            
            // Set the access control list to current user for security purposes
            //userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
//            
            [comic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //[self refresh:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
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

-(UIImage *)resizeImage:(UIImage *)image
{
    CGRect rect = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *transformedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imgData = UIImagePNGRepresentation(transformedImage);
    UIImage *finalImage = [UIImage imageWithData:imgData];
    
    return finalImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toSearch"])
    {
        if ([segue.destinationViewController isKindOfClass:[SearchComicsTableViewController class]])
        {
            SearchComicsTableViewController *searchController = segue.destinationViewController;
            
            searchController.searchTerm =  self.searchTerm;
        }
    }
    
}
@end
