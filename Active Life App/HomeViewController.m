//
//  HomeViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "HomeViewController.h"


@interface HomeViewController ()<SWRevealViewControllerDelegate>
{
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UITableView *eventTableView;
    IBOutlet UIScrollView *eventScrollView;
    IBOutlet MKMapView *eventMapView;
//    IBOutlet UIBarButtonItem* revealButtonItem;
}
@property (nonatomic, strong) NSDictionary *responseDict;

-(IBAction)btnLogOutPressed:(id)sender;
-(IBAction)btnMenuPressed:(id)sender;
-(IBAction)SegmentControlActions:(id)sender;

@end

@implementation HomeViewController

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
    
    NSLog(@"navigationController..%@",self.navigationController);
    _responseDict = [[NSDictionary alloc] init];
    _responseDict = (NSDictionary *)[Helper ReadFromJSONStore:@"Home.json"];
    NSLog(@"responseDict..%@",_responseDict);
//    lblEvent.text = [_responseDict valueForKey:@"Event_name"];
//    lblLocation.text = [_responseDict valueForKey:@"Location"];
//    lblTimeDate.text = [_responseDict valueForKey:@"Time/Date"];
//    lblHost.text = [_responseDict valueForKey:@"Host"];
//    lblDetails.text = [_responseDict valueForKey:@"Details"];

    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
}

-(IBAction)btnLogOutPressed:(id)sender{
    UINavigationController *navController =(UINavigationController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    [navController popViewControllerAnimated:YES];
}

-(IBAction)btnMenuPressed:(id)sender{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController revealToggle:nil];
}

-(IBAction)SegmentControlActions:(id)sender{
    NSLog(@"sender..%i",[segmentControl selectedSegmentIndex]);
    if ([segmentControl selectedSegmentIndex] == 0) {
        eventTableView.hidden = NO;
        eventScrollView.hidden = NO;
        eventMapView.hidden = YES;
        NSLog(@"ListView");
    }
    else if ([segmentControl selectedSegmentIndex] == 1)
    {
        eventTableView.hidden = YES;
        eventScrollView.hidden = YES;
        eventMapView.hidden = NO;
        NSLog(@"Map View");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_responseDict valueForKey:@"Events"] count];
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,22)];
//    tempView.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:80.0/255.0 blue:161.0/255.0 alpha:1.0];
//    tempView.tag = section;
//    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0,300,22)];
//    tempLabel.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:80.0/255.0 blue:161.0/255.0 alpha:1.0];
//    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
//    tempLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
//    
//    tempLabel.text = [[[_responseDict valueForKey:@"Events"] allKeys] objectAtIndex:section];
//    [tempView addSubview:tempLabel];
//    return tempView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventDetailCell";
    UITableViewCell *cell;
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 150, 20)];
    senderLabel.font = [UIFont boldSystemFontOfSize:18.0];
    senderLabel.text = [[[_responseDict valueForKey:@"Events"]objectAtIndex:indexPath.row] valueForKey:@"event_name"];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 80, 20)];
    locationLabel.font = [UIFont boldSystemFontOfSize:15.0];
    locationLabel.text = [[[_responseDict valueForKey:@"Events"]objectAtIndex:indexPath.row] valueForKey:@"Location"];

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, 100, 20)];
    timeLabel.font = [UIFont boldSystemFontOfSize:15.0];
    timeLabel.text = [[[_responseDict valueForKey:@"Events"]objectAtIndex:indexPath.row] valueForKey:@"Time"];

    [cell.contentView addSubview:senderLabel];
    [cell.contentView addSubview:locationLabel];
    [cell.contentView addSubview:timeLabel];
    return cell;
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

@end
