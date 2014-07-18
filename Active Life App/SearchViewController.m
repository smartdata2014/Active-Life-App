//
//  SearchViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<SWRevealViewControllerDelegate>
{
    IBOutlet UITableView *tableView;
}
-(IBAction)btnMenuPressed:(id)sender;
@property (nonatomic, strong) NSMutableArray *responseArr;
@property (nonatomic, strong) NSMutableArray *searchArr;
@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController
bool searching=0;

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
    _responseArr = [[NSMutableArray alloc] init];
    _searchArr = [[NSMutableArray alloc] init];
    _responseArr = (NSMutableArray *)[[Helper ReadFromJSONStore:@"Search.json"]valueForKey:@"Events"];
    NSLog(@"_responseArr..%@",_responseArr);
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
}

-(IBAction)btnMenuPressed:(id)sender{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController revealToggle:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searching ? [_searchArr count]:[_responseArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    UITableViewCell *cell;
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 220, 20)];
    senderLabel.font = [UIFont boldSystemFontOfSize:15.0];
    senderLabel.text = searching ? [_searchArr objectAtIndex:indexPath.row] : [_responseArr objectAtIndex:indexPath.row];
    [cell.contentView addSubview:senderLabel];
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"searchText..%@",searchText);
    searching = searchText.length ?1:0;
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@",searchText];
    NSArray *tempArray = [_responseArr filteredArrayUsingPredicate:predicate];
    _searchArr = [NSMutableArray arrayWithArray:tempArray];
    [tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searching = 0;
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    searching = 0;
    [searchBar resignFirstResponder];
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
