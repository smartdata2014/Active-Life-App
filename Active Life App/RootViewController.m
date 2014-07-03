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
    LoginViewController *logInViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:logInViewController animated:YES];
}


@end
