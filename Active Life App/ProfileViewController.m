//
//  ProfileViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()<SWRevealViewControllerDelegate>
{
    IBOutlet UILabel *lblName, *lblPlace, *lblInterestTags, *lblAboutMe;
    IBOutlet UIImageView *imgProfilePic;
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UITableView *eventTableView;
}
-(IBAction)btnLogOutPressed:(id)sender;
-(IBAction)btnMenuPressed:(id)sender;
@property (nonatomic, strong) NSDictionary *responseDict;
@property (nonatomic, strong) NSMutableArray *arrEvents;

@end

@implementation ProfileViewController

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
    self.navigationController.navigationBarHidden = YES;
    _responseDict = [[NSDictionary alloc] init];
    _arrEvents = [[NSMutableArray alloc] init];
    _responseDict = (NSDictionary *)[Helper ReadFromJSONStore:@"Profile.json"];
    
    lblName.text = [_responseDict valueForKey:@"Name"];
    lblPlace.text = [_responseDict valueForKey:@"Location"];
    lblInterestTags.text = [_responseDict valueForKey:@"Interest Tags"];
    lblAboutMe.text = [_responseDict valueForKey:@"About me"];
    _arrEvents = [_responseDict valueForKey:@"My Events"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnMenuPressed:(id)sender{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController revealToggle:nil];
}

-(IBAction)btnLogOutPressed:(id)sender{
    UINavigationController *navController =(UINavigationController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    [navController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProfileCells";
    UITableViewCell *cell;                                               
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *lblEventName = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 120, 20)];
    lblEventName.font = [UIFont boldSystemFontOfSize:15.0];
    lblEventName.text = [[_arrEvents objectAtIndex:indexPath.row] valueForKey:@"Event"];
    
    UILabel *lblSport = [[UILabel alloc] initWithFrame:CGRectMake(140, 11, 120, 20)];
    lblSport.font = [UIFont boldSystemFontOfSize:15.0];
    lblSport.text = [[_arrEvents objectAtIndex:indexPath.row] valueForKey:@"Sports"];
    lblSport.textColor = [UIColor grayColor];

    [cell.contentView addSubview:lblEventName];
    [cell.contentView addSubview:lblSport];
    return cell;
}

-(IBAction)SegmentControlActions:(id)sender{
    if ([segmentControl selectedSegmentIndex] == 0) {
        _arrEvents = [_responseDict valueForKey:@"My Events"];
    }
    else if ([segmentControl selectedSegmentIndex] == 1)
    {
        _arrEvents = [_responseDict valueForKey:@"Went"];
    }
    else{
        _arrEvents = [_responseDict valueForKey:@"Going"];
    }
    [eventTableView reloadData];
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
