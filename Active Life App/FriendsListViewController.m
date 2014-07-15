//
//  FriendsListViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "FriendsListViewController.h"

@interface FriendsListViewController (){
    IBOutlet UITableView *friendsTableView;
}

@property (nonatomic, strong) NSArray *arrFriends;
@end

@implementation FriendsListViewController

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
    self.navigationItem.title = @"Add Friends";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(BackPressed)];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    _arrFriends = [[NSArray alloc] init];
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        _arrFriends = [result objectForKey:@"data"];
        NSLog(@"friends..%@",_arrFriends);
        NSLog(@"Found: %i friends", _arrFriends.count);
        for (NSDictionary<FBGraphUser>* friend in _arrFriends) {
            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [friendsTableView reloadData];
}

-(void)BackPressed{
    UINavigationController *navController =(UINavigationController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    [navController popViewControllerAnimated:YES];
}

-(IBAction)SegmentControlActions:(id)sender{
//    if ([segmentControl selectedSegmentIndex] == 0) {
//        _arrEvents = [_responseDict valueForKey:@"My Events"];
//    }
//    else if ([segmentControl selectedSegmentIndex] == 1)
//    {
//        _arrEvents = [_responseDict valueForKey:@"Went"];
//    }
//    else{
//        _arrEvents = [_responseDict valueForKey:@"Going"];
//    }
    [friendsTableView reloadData];
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
    return [_arrFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCells";
    UITableViewCell *cell;
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 220, 20)];
    senderLabel.font = [UIFont boldSystemFontOfSize:15.0];
    senderLabel.text = [[_arrFriends objectAtIndex:indexPath.row] valueForKey:@"name"];
    senderLabel.textColor = [UIColor blackColor];
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
