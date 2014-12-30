//
//  EditComicViewController.h
//  MyComics
//
//  Created by Michael Thomas on 7/25/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Defines.h"

@interface EditComicViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) PFObject *comic;
@property (strong, nonatomic) UIImageView *comicImage;
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

- (IBAction)saveEditButton:(UIButton *)sender;
- (IBAction)takePictureButton:(UIButton *)sender;
- (IBAction)selectPictureButton:(UIButton *)sender;

@end
