//
//  ProfileViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()<SWRevealViewControllerDelegate,UIScrollViewDelegate>
{
    IBOutlet UILabel *lblName, *lblPlace, *lblInterestTags, *lblAboutMe;
    IBOutlet UIImageView *imgProfilePic;
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UITableView *eventTableView;
    IBOutlet UIScrollView *scrollView;
}
-(IBAction)btnLogOutPressed:(id)sender;
-(IBAction)btnMenuPressed:(id)sender;
-(IBAction)btnGetNextIcons:(id)sender;
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
    
//  lblName.text = [_responseDict valueForKey:@"Name"];
//  lblPlace.text = [_responseDict valueForKey:@"Location"];
//  lblInterestTags.text = [_responseDict valueForKey:@"Interest Tags"];
//  lblAboutMe.text = [_responseDict valueForKey:@"About me"];
    
    _arrEvents = [_responseDict valueForKey:@"My Events"];
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(164, 198, 145, 100);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;

    float count1 = 20.0;
    float count2 = ceilf(count1/7.0);
    for (int i=0; i<count2; i++) {
        int k;
        if (i==(count2-1)) {
            k = count1 - (i*7);
        }
        else{
            k = 7;
        }
        for (int j=0; j<k; j++) {
            if (j<4) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(33*j+8 ,05, 25, 40)];
                [imageView setBackgroundColor:[UIColor redColor]];
                [scrollView addSubview:imageView];
            }
            else{
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(33*(j-4)+8 ,50, 25, 40)];
                [imageView setBackgroundColor:[UIColor redColor]];
                [scrollView addSubview:imageView];
            }
        }
        UIButton *btnNext = [[UIButton alloc] initWithFrame:CGRectMake(33*3+8 ,50, 25, 40)];
        [btnNext addTarget:self action:@selector(btnGetNextIcons:) forControlEvents:UIControlEventTouchUpInside];
        btnNext.tag = 100 + (i+1);
        [btnNext setBackgroundColor:[UIColor blueColor]];
        [scrollView addSubview:btnNext];
        scrollView.contentSize = CGSizeMake(145*(i+1),100);
    }
//    scrollView.contentSize = CGSizeMake(800,100);
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
//    [scrollView scrollRectToVisible:CGRectMake(290, 145, 145, 100) animated:YES];
    // Do any additional setup after loading the view.
}

-(IBAction)btnGetNextIcons:(UIButton *)sender{
    NSLog(@"sender.tag....%i",[sender tag]);
    [scrollView setContentOffset:CGPointMake(140*([sender tag]-100), 0) animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
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
    
    UILabel *lblEventName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 25)];
    lblEventName.font = [UIFont systemFontOfSize:20.0];
    lblEventName.text = [[_arrEvents objectAtIndex:indexPath.row] valueForKey:@"Event"];
    
    UILabel *lblSport = [[UILabel alloc] initWithFrame:CGRectMake(30, 35, 120, 22)];
    lblSport.font = [UIFont systemFontOfSize:16.0];
    lblSport.text = [[_arrEvents objectAtIndex:indexPath.row] valueForKey:@"Sports"];
    lblSport.textColor = [UIColor grayColor];

    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(135, 35, 120, 22)];
    lblTime.font = [UIFont systemFontOfSize:16.0];
    lblTime.text = @"6 pm";
//    lblTime.text = [[_arrEvents objectAtIndex:indexPath.row] valueForKey:@"lblTime"];
    lblTime.textColor = [UIColor grayColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 20, 40, 40)];
    iconImageView.image = [UIImage imageNamed:@"Home"];

    [cell.contentView addSubview:lblEventName];
    [cell.contentView addSubview:lblSport];
    [cell.contentView addSubview:lblTime];
    [cell.contentView addSubview:iconImageView];

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
