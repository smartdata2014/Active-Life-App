//
//  MenuViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
{
    NSArray *menuArray;
}
@end

@implementation MenuViewController

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
    menuArray = [[NSMutableArray alloc] initWithObjects:@"Home",@"Search",@"Notifications",@"Activities",@"Create",@"Profile",@"Settings",nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    tempView.backgroundColor=[UIColor blueColor];
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,2,300,20)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.shadowColor = [UIColor blackColor];
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont boldSystemFontOfSize:15];
    tempLabel.text = @"Menu";
    [tempView addSubview:tempLabel];
    return tempView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 220, 20)];
    senderLabel.font = [UIFont boldSystemFontOfSize:15.0];
    senderLabel.text = [menuArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:senderLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController;
    if(indexPath.row == 0)
    {
//        HomeViewController *homeViewController= [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"HomeViewController"];
//        frontViewController = homeViewController;
        FriendsListViewController *friendsListViewController= [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"FriendsListViewController"];
        frontViewController = friendsListViewController;
    }
    else if (indexPath.row == 1)
    {
        SearchViewController *searchViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"SearchViewController"];
        frontViewController = searchViewController;
    }
    else if (indexPath.row == 2)
    {
        NotificationsViewController *notificationsViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"NotificationsViewController"];
        frontViewController = notificationsViewController;
    }
    else if (indexPath.row == 3)
    {
        AcivitiesViewController *acivitiesViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"AcivitiesViewController"];
        frontViewController = acivitiesViewController;
    }
    else if (indexPath.row == 4)
    {
        CreateEventViewController *createEventViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"CreateEventViewController"];
        frontViewController = createEventViewController;
    }
    else if (indexPath.row == 5)
    {
        ProfileViewController *profileViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        frontViewController = profileViewController;
    }
    else if (indexPath.row == 6)
    {
//        SettingsViewController *settingsViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"SettingsViewController"];
//        frontViewController = settingsViewController;
        EventDetailsViewController *eventDetailsViewController = [[AppDelegate storyBoard] instantiateViewControllerWithIdentifier:@"EventDetailsViewController"];
        frontViewController = eventDetailsViewController;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    navigationController.navigationBar.translucent = YES;
    navigationController.navigationBar.tintColor = [UIColor colorWithRed:14.0/255.0 green:112.0/255.0 blue:220.0 /255.0 alpha:1.0];

    [revealController pushFrontViewController:navigationController animated:YES];
}

-(IBAction)btnMenuPressed:(id)sender{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController revealToggle:nil];
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
