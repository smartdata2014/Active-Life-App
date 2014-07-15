//
//  EventDetailsViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()<SWRevealViewControllerDelegate>{
    IBOutlet UILabel *lblEvent, *lblLocation, *lblTimeDate, *lblHost, *lblDetails;
}

-(IBAction)btnMenuPressed:(id)sender;
-(IBAction)btnRespondRequestPressed:(id)sender;
-(IBAction)btnBackPressed:(id)sender;
@property (nonatomic, strong) NSDictionary *responseDict;
@end

@implementation EventDetailsViewController

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
    _responseDict = (NSDictionary *)[Helper ReadFromJSONStore:@"EventDetails.json"];
    NSLog(@"responseDict..%@",_responseDict);
    lblEvent.text = [_responseDict valueForKey:@"Event_name"];
    lblLocation.text = [_responseDict valueForKey:@"Location"];
    lblTimeDate.text = [_responseDict valueForKey:@"Time/Date"];
    lblHost.text = [_responseDict valueForKey:@"Host"];
    lblDetails.text = [_responseDict valueForKey:@"Details"];
    
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

-(IBAction)btnBackPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnRespondRequestPressed:(id)sender{
    if ([sender tag]==10) {
        NSLog(@"Respond");
    }
    else{
        NSLog(@"Request");
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[_responseDict valueForKey:@"Friends"] allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_responseDict valueForKey:@"Friends"]valueForKey:[[[_responseDict valueForKey:@"Friends"] allKeys] objectAtIndex:section]] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,22)];
    tempView.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:80.0/255.0 blue:161.0/255.0 alpha:1.0];
    tempView.tag = section;
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0,300,22)];
    tempLabel.backgroundColor=[UIColor colorWithRed:63.0/255.0 green:80.0/255.0 blue:161.0/255.0 alpha:1.0];
    tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
    tempLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    tempLabel.text = [[[_responseDict valueForKey:@"Friends"] allKeys] objectAtIndex:section];
    [tempView addSubview:tempLabel];
    return tempView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventDetailCell";
    UITableViewCell *cell;
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 220, 20)];
    senderLabel.font = [UIFont boldSystemFontOfSize:15.0];
    senderLabel.text = [[[_responseDict valueForKey:@"Friends"]valueForKey:[[[_responseDict valueForKey:@"Friends"] allKeys] objectAtIndex:indexPath.section] ] objectAtIndex:indexPath.row];
    [cell.contentView addSubview:senderLabel];
    return cell;
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
