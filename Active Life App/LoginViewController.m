//
//  LoginViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<SWRevealViewControllerDelegate,FBLoginViewDelegate>
{
    IBOutlet UIView *forgotPasswordView;
    IBOutlet UITextField *txtUsername, *txtPassword;
}

@property (strong, nonatomic) IBOutlet FBLoginView *fbLoginView;

-(IBAction)btnLoginPressed:(id)sender;
-(IBAction)btnSignUpPressed:(id)sender;
-(IBAction)btnSignUpWithFacebookPressed:(id)sender;
-(IBAction)btnForgotPasswordPressed:(id)sender;
-(IBAction)forgotPasswordViewBtnActions:(id)sender;

@end

@implementation LoginViewController

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
    
    NSLog(@"Login");
    self.navigationItem.title = @"LogIn";
    [_fbLoginView setReadPermissions:@[@"basic_info"]];
    [_fbLoginView setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnLoginPressed:(id)sender{
//    HomeViewController *homeViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"HomeViewController"];
//    [self.navigationController pushViewController:homeViewController animated:YES];
//    SWRevealViewController *revealController = [self revealViewController];
    MenuViewController *rearViewController;
    HomeViewController *frontViewController;
    frontViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    rearViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"MenuViewController"];
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    frontNavigationController.navigationBar.translucent = YES;
    frontNavigationController.navigationBarHidden = YES;

    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    rearNavigationController.navigationBar.translucent = YES;
    rearNavigationController.navigationBarHidden = YES;
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                    initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    mainRevealController.delegate = self;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:mainRevealController animated:YES];
}

-(IBAction)btnSignUpPressed:(id)sender{
    SignUpViewController *signUpViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

-(IBAction)btnSignUpWithFacebookPressed:(id)sender{
    [FBLoginView class];
    [FBProfilePictureView class];
    
    // Create a GraphAPICallsViewController instance from where we will make the Graph API calls
//    GraphAPICallsViewController *graphAPICallsViewController = [[GraphAPICallsViewController alloc] init];
//    
//    // Set loginUIViewController as root view controller
//    [[self window] setRootViewController:graphAPICallsViewController];

}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
//    self.profilePictureView.profileID = user.id;
//    self.nameLabel.text = user.name;
    
    [self btnLoginPressed:nil];
}


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


-(IBAction)btnForgotPasswordPressed:(id)sender{
    forgotPasswordView.hidden = NO;
}

-(IBAction)forgotPasswordViewBtnActions:(id)sender{

    if ([sender tag]==10) {
        [forgotPasswordView setHidden:YES];
    }
    else{
        NSLog(@"Email the password");
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

@end
