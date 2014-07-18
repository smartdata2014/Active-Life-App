//
//  ViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
        [self performSelector:@selector(goToLogin) withObject:self afterDelay:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToLogin{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:14.0/255.0 green:112.0/255.0 blue:220.0 /255.0 alpha:1.0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Helvetica light" size:13], NSFontAttributeName,
                                      nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:normalAttributes
                                                forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Arial" size:19.0],
      NSFontAttributeName,
      nil]];
    
    LoginViewController *logInViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:logInViewController animated:YES];
}


@end
