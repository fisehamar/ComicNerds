//
//  AddComicViewController.h
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Defines.h"

@interface AddComicViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSString *searchTerm;

@property (strong, nonatomic) IBOutlet UIImageView *comicImage;
@property (strong, nonatomic) IBOutlet UITextField *titleNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *authorTextField;
@property (strong, nonatomic) IBOutlet UITextField *artistTextField;
@property (strong, nonatomic) IBOutlet UITextField *publisherTextField;
@property (strong, nonatomic) IBOutlet UITextField *issueNumTextField;
@property (strong, nonatomic) IBOutlet UITextField *publicationDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *commentsTextField;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;
@property (strong, nonatomic) IBOutlet UIButton *selectPhotoButton;

- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)addComicButton:(id)sender;
- (IBAction)takePictureButton:(UIButton *)sender;
- (IBAction)selectPictureButton:(UIButton *)sender;

@end
