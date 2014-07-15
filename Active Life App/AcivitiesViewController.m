//
//  AcivitiesViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "AcivitiesViewController.h"

@interface AcivitiesViewController ()<SWRevealViewControllerDelegate>
{
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UITableView *tblActivities;
}
-(IBAction)btnMenuPressed:(id)sender;

@property (nonatomic, strong) NSDictionary *responseDict;
@property (nonatomic, strong) NSMutableArray *arrEvents;
@end


@implementation AcivitiesViewController

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
    _responseDict = (NSDictionary *)[Helper ReadFromJSONStore:@"Activities.json"];
    _arrEvents = [_responseDict valueForKey:@"Going Events"];
    
    NSLog(@"responseDict..%@",_responseDict);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78.0;
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
    static NSString *CellIdentifier = @"ActivityCells";
    UITableViewCell *cell;
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *EventName = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 120, 20)];
    EventName.font = [UIFont boldSystemFontOfSize:18.0];
    EventName.text = [[_arrEvents objectAtIndex:indexPath.row] valueForKey:@"event_name"];
    [cell.contentView addSubview:EventName];
    
    UILabel *Date = [[UILabel alloc] initWithFrame:CGRectMake(10, 42, 170, 20)];
    Date.font = [UIFont boldSystemFontOfSize:15.0];
    Date.text = [[_arrEvents objectAtIndex:indexPath.row] valueForKey:@"Time"];
    [cell.contentView addSubview:Date];
    
    return cell;
}

-(IBAction)SegmentControlActions:(id)sender{
    
    if ([segmentControl selectedSegmentIndex] == 0) {
        _arrEvents = [_responseDict valueForKey:@"Going Events"];
    }
    else if ([segmentControl selectedSegmentIndex] == 1)
    {
        _arrEvents = [_responseDict valueForKey:@"Invited Events"];
    }
    [tblActivities reloadData];
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
