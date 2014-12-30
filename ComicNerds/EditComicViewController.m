//
//  EditComicViewController.m
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import "EditComicViewController.h"

@interface EditComicViewController ()

@end

@implementation EditComicViewController

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
    
    self.titleNameTextField.delegate = self;
    self.authorTextField.delegate = self;
    self.artistTextField.delegate = self;
    self.publisherTextField.delegate = self;
    self.issueNumTextField.delegate = self;
    //self.volumeNumLabel.delegate = self;
    self.publicationDateTextField.delegate = self;
    self.commentsTextField.delegate = self;
    
    self.titleNameTextField.text = self.comic[USERSCOMICSTITLENAME];
    self.authorTextField.text = self.comic[USERSCOMICSAUTHOR];
    self.artistTextField.text = self.comic[USERSCOMICSARTIST];
    self.publisherTextField.text = self.comic[USERSCOMICSPUBLISHER];
    self.issueNumTextField.text = self.comic[USERSCOMICSISSUENUM];
    //self.volumeNumLabel.text = self.comic[USERSCOMICSVOLUMENUM];
    self.publicationDateTextField.text = self.comic[USERSCOMICSPUBLICATIONDATE];
    self.commentsTextField.text = self.comic[USERSCOMICSCOMMENTS];
    self.comicImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 100, 100)];
    
    PFFile *theImage = [self.comic objectForKey:USERSCOMICSCOVERIMAGE];
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    self.comicImage.image = image;
    [self.view addSubview:self.comicImage];
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
- (IBAction)saveEditedComic:(id)sender
{
    NSData *imageData = UIImageJPEGRepresentation(self.comicImage.image, 0.05f);
    [self uploadImage:imageData];
    
    //    [self.comic saveInBackground];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveEditButton:(id)sender
{
    NSData *imageData = UIImageJPEGRepresentation(self.comicImage.image, 0.05f);
    [self uploadImage:imageData];
    
//    [self.comic saveInBackground];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)takePictureButton:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [picker.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"MyComicsLogoNavBar.png"] forBarMetrics:UIBarMetricsDefault];

    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPictureButton:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    [picker.navigationController.navigationBar setTintColor:[UIColor blueColor]];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if (!chosenImage) {
        chosenImage = info[UIImagePickerControllerOriginalImage];
    }
    self.comicImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


-(void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    //HUD creation here (see example for code)
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            
            // Create a PFObject around a PFFile and associate it with the current user
            //self.comic = [PFObject objectWithClassName:USERSCOMICSCLASS];
            
            [self.comic setObject:imageFile forKey:USERSCOMICSCOVERIMAGE];
            self.comic[USERSCOMICSTITLENAME] = self.titleNameTextField.text;
            self.comic[USERSCOMICSAUTHOR] = self.authorTextField.text;
            self.comic[USERSCOMICSARTIST] = self.artistTextField.text;
            self.comic[USERSCOMICSPUBLISHER] = self.publisherTextField.text;
            self.comic[USERSCOMICSISSUENUM] = self.issueNumTextField.text;
            //self.comic[USERSCOMICSVOLUMENUM] = self.volumeNumLabel.text;
            self.comic[USERSCOMICSPUBLICATIONDATE] = self.publicationDateTextField.text;
            self.comic[USERSCOMICSCOMMENTS] = self.commentsTextField.text;

            PFRelation *relation = [self.comic relationForKey:USERSCOMICSUSER];
            [relation addObject:[PFUser currentUser]];
            [self.comic saveInBackground];
//            [self.comic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (!error) {
//                    //[self refresh:nil];
//                }
//                else{
//                    // Log details of the failure
//                    NSLog(@"Error: %@ %@", error, [error userInfo]);
//                }
//            }];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
