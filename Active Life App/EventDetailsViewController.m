//
//  EventDetailsViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()<SWRevealViewControllerDelegate>{
    IBOutlet UILabel *lblHost, *lblDetails;
    IBOutlet UIImageView *imageEvents;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UITableView *friendsTableView;
}

-(IBAction)btnMenuPressed:(id)sender;
-(IBAction)btnRespondRequestPressed:(id)sender;
-(IBAction)btnBackPressed:(id)sender;
-(IBAction)SegmentControlActions:(id)sender;
-(IBAction)btnJoinNowPressed:(id)sender;

@property (nonatomic, strong) NSDictionary *responseDict;
@property (nonatomic, strong) NSMutableArray *arrEvents;
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
    
    _arrEvents = [[NSMutableArray alloc] init];
    _arrEvents = [[_responseDict valueForKey:@"Friends"] valueForKey:@"Attending"];

    lblDetails.text = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
    
    NSLog(@"responseDict..%@",_responseDict);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 199)];
    imageView.image = [UIImage imageNamed:@"event_img"];
    
    UILabel *lblEvent = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 119, 25)];
    lblEvent.font = [UIFont systemFontOfSize:17.0];
    lblEvent.text = [_responseDict valueForKey:@"Event_name"];
    
    UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(20, 32, 129, 25)];
    lblLocation.font = [UIFont systemFontOfSize:17.0];
    lblLocation.textColor = [UIColor lightGrayColor];
    lblLocation.text = [_responseDict valueForKey:@"Location"];
    
    UILabel *lblTimeDate = [[UILabel alloc] initWithFrame:CGRectMake(162, 32, 49, 25)];
    lblTimeDate.font = [UIFont systemFontOfSize:17.0];
    lblTimeDate.textColor = [UIColor lightGrayColor];
    lblTimeDate.text = @"8 AM";
    lblTimeDate.text = [_responseDict valueForKey:@"Time/Date"];
    
    UIButton *btnJoinNow = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 105, 35)];
    [btnJoinNow setImage:[UIImage imageNamed:@"btn_joinnow"] forState:UIControlStateNormal];
    [btnJoinNow addTarget:self action:@selector(btnJoinNowPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:imageView];
    [scrollView addSubview:lblEvent];
    [scrollView addSubview:lblLocation];
    [scrollView addSubview:lblTimeDate];
    [scrollView addSubview:btnJoinNow];

//  lblHost.text = [_responseDict valueForKey:@"Host"];
    lblHost.text = [NSString stringWithFormat:@"   hosted by\n   %@",[_responseDict valueForKey:@"Host"]];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: lblHost.attributedText];
    [text addAttribute: NSFontAttributeName value: [UIFont italicSystemFontOfSize:16.0] range: NSMakeRange(0, [lblHost.text rangeOfString:@"\n"].location+1)];
    [lblHost setAttributedText: text];
    
    lblDetails.text = [_responseDict valueForKey:@"Details"];
    scrollView.backgroundColor = [UIColor orangeColor];
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

-(IBAction)SegmentControlActions:(id)sender{

    if ([segmentControl selectedSegmentIndex] == 0) {
        _arrEvents = [[_responseDict valueForKey:@"Friends"] valueForKey:@"Attending"];
    }
    else if ([segmentControl selectedSegmentIndex] == 1)
    {
        _arrEvents = [[_responseDict valueForKey:@"Friends"] valueForKey:@"Not Attending"];;
    }
    [friendsTableView reloadData];
}

-(IBAction)btnJoinNowPressed:(id)sender{
    NSLog(@"Join Now");
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrEvents count];
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
//    tempLabel.text = [[[_responseDict valueForKey:@"Friends"] allKeys] objectAtIndex:section];
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
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 220, 20)];
    senderLabel.font = [UIFont boldSystemFontOfSize:15.0];
    senderLabel.text = [_arrEvents objectAtIndex:indexPath.row];
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
