//
//  FriendsListViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "FriendsListViewController.h"
#import "Person.h"

@interface FriendsListViewController ()<FBFriendPickerDelegate,UISearchBarDelegate>{
  IBOutlet UITableView *friendsTableView;
  IBOutlet UISegmentedControl *segmentControl;
}

@property (nonatomic, strong) NSMutableArray *arrFriends;
@property (nonatomic, strong) NSMutableDictionary *postDict;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchText;
-(void)reloadTableView;

@end

@implementation FriendsListViewController

int segmentIndex;


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
    
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Select Friends";
        self.friendPickerController.delegate = self;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    // Present the friend picker
    [self presentViewController:self.friendPickerController
                       animated:YES
                     completion:^(void){
                         [self addSearchBarToFriendPickerView];
                     }
     ];
    _postDict = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
//    [self setSelectFriendsButton:nil];
//    [self setLoginView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.friendPickerController = nil;
    self.searchBar = nil;
}

-(void)viewWillAppear:(BOOL)animated{
     [self getFacebookFriends];
}

-(void)viewDidAppear:(BOOL)animated{

}

-(void)reloadTableView{
    [friendsTableView reloadData];
}

-(void)BackPressed{
    UINavigationController *navController =(UINavigationController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    [navController popViewControllerAnimated:YES];
}

-(IBAction)SegmentControlActions:(id)sender{
    segmentIndex = [segmentControl selectedSegmentIndex];
    if (segmentIndex == 0) {
        [self getFacebookFriends];
        
        if (self.friendPickerController == nil) {
            // Create friend picker, and get data loaded into it.
            self.friendPickerController = [[FBFriendPickerViewController alloc] init];
            self.friendPickerController.title = @"Select Friends";
            self.friendPickerController.delegate = self;
        }
        
        [self.friendPickerController loadData];
        [self.friendPickerController clearSelection];
        
        // Present the friend picker
        [self presentViewController:self.friendPickerController
                           animated:YES
                         completion:^(void){
                             [self addSearchBarToFriendPickerView];
                         }
         ];
    }
    else if (segmentIndex == 1)
    {
        [self getContactFromAddressBook];
    }
    else{
//        _arrFriends = [_responseDict valueForKey:@"Going"];
    }
    [friendsTableView reloadData];
}

- (void)addSearchBarToFriendPickerView
{
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask|
        UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        
        [self.friendPickerController.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.friendPickerController.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.friendPickerController.tableView.frame = newFrame;
    }
}

-(void) getFacebookFriends{
    _arrFriends = [[NSMutableArray alloc] init];
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
    [self performSelector:@selector(reloadTableView) withObject:self afterDelay:2.0];
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
    // If there is a search query, filter the friend list based on this.
    if (self.searchText && ![self.searchText isEqualToString:@""]) {
        NSRange result = [user.name
                          rangeOfString:self.searchText
                          options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound) {
            // If friend name matches partially, show the friend
            return YES;
        } else {
            // If no match, do not show the friend
            return NO;
        }
    } else {
        // If there is no search query, show all friends.
        return YES;
    }
    return YES;
}

- (void) handlePickerDone
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"Friend selection cancelled.");
    [self handlePickerDone];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        NSLog(@"Friend selected: %@", user.name);
    }
    [self handlePickerDone];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    // Trigger the search
    [self handleSearch:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    // Clear the search query and dismiss the keyboard
    self.searchText = nil;
    [searchBar resignFirstResponder];
}

- (void) handleSearch:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    [self.friendPickerController updateView];
}

-(void) getContactFromAddressBook
{
    _arrFriends = [[NSMutableArray alloc]init];
    BOOL isAcessed;
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        
#ifdef DEBUG
        NSLog(@"Fetching contact info ----> ");
#endif
        isAcessed = accessGranted;
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            // The user has previously given access, add the contact
            isAcessed = YES;
            NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
            
            //        CFArrayRef allPeople  = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex count = CFArrayGetCount((__bridge CFArrayRef)(allContacts));
            
            //To generate array of imported data;
            for (int i = 0; i < count; i++)
            {
                Person *person = [[Person alloc] init];
                
                ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
                
                NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                //NSString *phoneNo =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    
                    ABMultiValueRef phones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                    for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
                    {
                        //                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
                        //                    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
                        //                    NSString *phoneLabel = (__bridge NSString *) ABAddressBookCopyLocalizedLabel(locLabel);
                        //                    NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
                        //                    person.phoneNumber = phoneNumber;
                        //                    CFRelease(phoneNumberRef);
                        //                    CFRelease(locLabel);
                        //                    NSLog(@"  - %@ (%@)", phoneNumber, phoneLabel);
                        
                        
                        //                    CFStringRef locLabel1 = ABMultiValueCopyLabelAtIndex(phones, j);
                        //
                        //                    NSString *phoneLabel1 =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel1);
                        //                    CFRelease(locLabel1);
                        
                        NSString* phoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j);
                        
                        if (phoneNumber != nil || phoneNumber.length >0)
                        {
                            person.phoneNumber = phoneNumber;
                        }
                        
                        NSLog(@"phoneNumber %@ )", phoneNumber);
                    }
                }
                
                NSString *fullName;
                
                if (firstName && lastName )
                {
                    fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                }
                else if (firstName)
                {
                    fullName = [NSString stringWithFormat:@"%@", firstName];
                }
                else if (lastName)
                {
                    fullName = [NSString stringWithFormat:@"%@", lastName];
                }
                else
                {
                    fullName = nil;
                }
                
                NSLog(@"person details are  = %@ firstName = %@ lastName=%@", fullName,firstName, lastName);
                
                if (firstName)
                {
                    person.firstName = firstName;
                }
                if (lastName)
                {
                    person.lastName = lastName;
                }
                if (fullName != nil)
                {
                    person.fullName = fullName;
                }
                
                NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                NSLog(@"person.firstName = %@ ", person.firstName);
                NSLog(@"person.lastName = %@ ", person.lastName);
                NSLog(@"person.fullName = %@ ", person.fullName);
                NSLog(@"person.phoneNumber = %@ ", person.phoneNumber);
                
                ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
                
                NSUInteger j = 0;
                for (j = 0; j < ABMultiValueGetCount(emails); j++)
                {
                    NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                    if (j == 0)
                    {
                        if (email)
                        {
                            person.homeEmail = email;
                        }
                        NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                    }
                    
                    else if (j==1)
                        person.workEmail = email;
                }
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    if (person.phoneNumber != nil)
                    {
                        if (person.phoneNumber != nil)
                        {
                            if (person.fullName != nil)
                            {
                                [_arrFriends addObject:person];
                            }
                        }
                    }
                    
                }
                else
                {
                    if (person.homeEmail != nil)
                    {
                        if (person.fullName != nil)
                        {
                            [_arrFriends addObject:person];
                        }
                    }
                }
                
                //clientObject = nil;
            }
            NSLog(@"data collection :- %@",_arrFriends);
            [friendsTableView reloadData];
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            // The user has previously given access, add the contact
            isAcessed = YES;
            NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
            
            //        CFArrayRef allPeople  = ABAddressBookCopyArrayOfAllPeople(addressBook);
            CFIndex count = CFArrayGetCount((__bridge CFArrayRef)(allContacts));
            
            //To generate array of imported data;
            for (int i = 0; i < count; i++)
            {
                Person *person = [[Person alloc] init];
                
                ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
                
                NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
                NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                //NSString *phoneNo =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    
                    ABMultiValueRef phones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
                    for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
                    {
                        //                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
                        //                    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
                        //                    NSString *phoneLabel = (__bridge NSString *) ABAddressBookCopyLocalizedLabel(locLabel);
                        //                    NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
                        //                    person.phoneNumber = phoneNumber;
                        //                    CFRelease(phoneNumberRef);
                        //                    CFRelease(locLabel);
                        //                    NSLog(@"  - %@ (%@)", phoneNumber, phoneLabel);
                        
                        
                        //                    CFStringRef locLabel1 = ABMultiValueCopyLabelAtIndex(phones, j);
                        //
                        //                    NSString *phoneLabel1 =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel1);
                        //                    CFRelease(locLabel1);
                        
                        
                        NSString* phoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j);
                        
                        if (phoneNumber != nil || phoneNumber.length >0)
                        {
                            person.phoneNumber = phoneNumber;
                        }
                        
                        NSLog(@"phoneNumber %@ )", phoneNumber);
                    }
                    
                }
                
                NSString *fullName;
                
                if (firstName && lastName )
                {
                    fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                }
                else if (firstName)
                {
                    fullName = [NSString stringWithFormat:@"%@", firstName];
                }
                else if (lastName)
                {
                    fullName = [NSString stringWithFormat:@"%@", lastName];
                }
                else
                {
                    fullName = nil;
                }
                
                
                NSLog(@"person details are  = %@ firstName = %@ lastName=%@", fullName,firstName, lastName);
                
                if (firstName)
                {
                    person.firstName = firstName;
                }
                if (lastName)
                {
                    person.lastName = lastName;
                }
                if (fullName != nil)
                {
                    person.fullName = fullName;
                }
                
                NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                NSLog(@"person.firstName = %@ ", person.firstName);
                NSLog(@"person.lastName = %@ ", person.lastName);
                NSLog(@"person.fullName = %@ ", person.fullName);
                NSLog(@"person.phoneNumber = %@ ", person.phoneNumber);
                
                ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
                
                NSUInteger j = 0;
                for (j = 0; j < ABMultiValueGetCount(emails); j++)
                {
                    NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                    if (j == 0)
                    {
                        if (email)
                        {
                            person.homeEmail = email;
                        }
                        NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                    }
                    
                    else if (j==1)
                        person.workEmail = email;
                }
                [_arrFriends addObject:person];

//                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//                {
//                    if (person.phoneNumber != nil)
//                    {
//                        if (person.phoneNumber != nil)
//                        {
//                            if (person.fullName != nil)
//                            {
//                                [_arrFriends addObject:person];
//                            }
//                        }
//                    }
//                    
//                }
//                else
//                {
//                    if (person.homeEmail != nil)
//                    {
//                        if (person.fullName != nil)
//                        {
//                            [_arrFriends addObject:person];
//                        }
//                    }
//                }
                
                //clientObject = nil;
            }
            NSLog(@"data collection :- %@",_arrFriends);
            [friendsTableView reloadData];
        }
    } else {
#ifdef DEBUG
        //        UIAlertView *accssAlert = [[UIAlertView alloc]initWithTitle:AlertTitle message:@"There is no permession to access contacts. Go to settings -> Privacy -> Enable contacts" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [accssAlert show];
        
        NSLog(@"Cannot fetch Contacts :( ");
#endif
    }
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
    
    if (segmentIndex == 0) {
        senderLabel.text = [[_arrFriends objectAtIndex:indexPath.row] valueForKey:@"name"];
    }
    else{
        Person *person = [_arrFriends objectAtIndex:indexPath.row];
        senderLabel.text = [NSString stringWithFormat:@"%@",person.firstName];
    }

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
