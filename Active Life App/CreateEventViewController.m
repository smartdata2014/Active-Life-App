//
//  CreateEventViewController.m
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import "CreateEventViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "Person.h"

@interface CreateEventViewController ()<SWRevealViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UITextField *txtName, *txtTime, *txtPlace, *txtActivity;
    IBOutlet UITableView *tableFriends;
}
@property (nonatomic, strong) NSMutableArray *arrFriends;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
-(IBAction)btnActionSegmentControl:(id)sender;
-(IBAction)btnMenuPressed:(id)sender;
-(IBAction)btnCreatePressed:(id)sender;

@property (nonatomic, strong) NSMutableDictionary *responseDict;
@end

@implementation CreateEventViewController
@synthesize eventStoreCalendarIdentifier;
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
    self.navigationController.navigationBarHidden = YES;
    _responseDict = [[NSMutableDictionary alloc] init];
    [_responseDict setObject:@"Private" forKey:@"Privacy"];
    [_responseDict setObject:@"Male" forKey:@"Gender"];
    
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

    NSLog(@"_arrFriends...%@",_arrFriends);
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self getFacebookFriends];
}

-(void)reloadTableView{
    [tableFriends reloadData];
}

-(IBAction)btnActionSegmentControl:(id)sender{
    
    segmentIndex = [segmentControl selectedSegmentIndex];
    if (segmentIndex == 0) {
        [self getFacebookFriends];
      }
    else if (segmentIndex == 1)
    {
        [self getContactFromAddressBook];
    }
       [tableFriends reloadData];
}

-(void)getFacebookFriends{
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


-(void)getContactFromAddressBook
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
            [tableFriends reloadData];
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
            [tableFriends reloadData];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CreateEventCells";
    UITableViewCell *cell;
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    UILabel *senderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 220, 20)];
    senderLabel.font = [UIFont boldSystemFontOfSize:15.0];
    if (segmentIndex == 0) {
//        senderLabel.text = [[_arrFriends objectAtIndex:indexPath.row] valueForKey:@"name"];
        senderLabel.text = @"Friedns";
    }
    else{
        Person *person = [_arrFriends objectAtIndex:indexPath.row];
        senderLabel.text = [NSString stringWithFormat:@"%@",person.firstName];
    }
    [cell.contentView addSubview:senderLabel];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 05, 20, 20)];
    [imageView setImage:[UIImage imageNamed:@"Home.png"]];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell.contentView...%@",[cell.contentView subviews]);

    if ([[cell.contentView subviews] count]>1 ) {
        if ([[[cell.contentView subviews] objectAtIndex:1] isKindOfClass:[UIImageView class]]) {
            UIImageView *image = (UIImageView *)[cell.contentView.subviews objectAtIndex:1];
            [image removeFromSuperview];
        }
        NSLog(@"Conmtains Image");
    }
    else{
        [cell.contentView addSubview:imageView];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(IBAction)btnCreatePressed:(id)sender{
    [_responseDict setObject:txtName.text forKey:@"Name"];
    [_responseDict setObject:txtTime.text forKey:@"Time"];
    [_responseDict setObject:txtPlace.text forKey:@"Place"];
    [_responseDict setObject:txtActivity.text forKey:@"Activity"];
    NSLog(@"_responseDict..%@",_responseDict);
    [AlertView showAlertwithTitle:@"Success" message:@"Event has been created successfully"];
}

-(IBAction)btnLogOutPressed:(id)sender{
    UINavigationController *navController =(UINavigationController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    [navController popViewControllerAnimated:YES];
}

-(void)synchroniseEventsWithDeviceCalender{
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:@"5" forKey:@"month"];
    [postDict setObject:@"2014" forKey:@"year"];
    [postDict setObject:@"14" forKey:@"trainer_id"];

    NSDictionary *returnDict = [[NSDictionary alloc] init];
    
    if ([[returnDict objectForKey:@"success"] boolValue]) {
        NSMutableArray *shiftsArray=[[returnDict objectForKey:@"data"] mutableCopy];
        
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        NSArray *cals = [eventStore calendarsForEntityType: EKEntityTypeEvent];
        
        NSError* error = nil;
        for (EKCalendar *cal in cals) {
            if ([cal.title isEqualToString:@"Active Life Calendar"]) {
                BOOL result = [eventStore removeCalendar:cal commit:YES error:&error];
                if (result) {
                    NSLog(@"Deleted calendar from event store.");
                }
            }
        }
        
        EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
        calendar.title = @"Active Life Calendar";
        EKSource* localSource = nil;
        EKSource* iCloudSource = nil;
        EKSource* mailSource = nil;
        EKSource* subscribedSource = nil;
        
        for (EKSource* source in eventStore.sources){
            if (source.sourceType == EKSourceTypeLocal){
                localSource = source;
            }else if(source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"]){
                iCloudSource = source;
            }else if(source.sourceType == EKSourceTypeSubscribed){
                subscribedSource = source;
            }else if(source.sourceType == EKSourceTypeCalDAV){
                mailSource = source;
            }
        }
        
        if (iCloudSource && [iCloudSource.calendars count] != 0) {
            calendar.source = iCloudSource;
            
        }else if(mailSource && [mailSource.calendars count] > 0){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Beyond fitness" message:@"Calendar Sync need the iCloud enabled, Please go to Settings > iCloud and enable Caledar to Sync shifts with Default calendar" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }else if(subscribedSource && [subscribedSource.calendars count] > 0){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Beyond fitness" message:@"Calendar Sync need the iCloud enabled, Please go to Settings > iCloud and enable Caledar to Sync shifts with Default calendar" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
            
        }else{
            calendar.source = localSource;
        }
        BOOL result = [eventStore saveCalendar:calendar commit:YES error:&error];
        
        if (result) {
            self.eventStoreCalendarIdentifier=calendar.calendarIdentifier;
            //                [eventIdArray addObject:self.eventStoreIdentifier];
            //                [[NSUserDefaults standardUserDefaults] setObject:eventIdArray forKey:@"eventStoreIdentifier"];
            //                [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        for (int i=0; i<[shiftsArray count]; i++)
        {
            NSDictionary *shiftDict = [shiftsArray objectAtIndex:i];
            NSArray *tempArray2 = [shiftDict objectForKey:@"eventData"];
            for (int k=0; k<[tempArray2 count]; k++)
            {
                if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
                    //            // iOS 6 and later
                    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                        if (error)
                        {
                            // display error message here
                            NSLog(@"error is %@",[error description]);
                            //----- codes here when user NOT allow your app to access the calendar.
                        }
                        else if (!granted)
                        {
                            // display access denied error message here
                        }
                        else
                        {
                            // access granted
                            // ***** do the important stuff here *****
                            //---- codes here when user allow your app to access theirs' calendar.
                            
                            NSDictionary *timeDict = [tempArray2 objectAtIndex:k];
                            //                                            EKEventStore *eventStore = [[EKEventStore alloc] init];
                            EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                            EKCalendar *calendar = [eventStore calendarWithIdentifier:self.eventStoreCalendarIdentifier];
                            event.calendar = calendar;
                            
                            NSString *startDateStr = [NSString stringWithFormat:@"%@ %@",[shiftDict objectForKey:@"eventDate"],[timeDict objectForKey:@"time"]];
                            NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
                            [startDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                            //                                            [startDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
                            NSDate *startDate = [startDateFormatter dateFromString:startDateStr];
                            NSDate *endDate;
                            if ([[timeDict objectForKey:@"time_limit"] isEqualToString:@"30 minutes"]) {
                                
                                endDate = [startDate dateByAddingTimeInterval:30*60];
                            }else{
                                endDate = [startDate dateByAddingTimeInterval:[[[timeDict objectForKey:@"time_limit"] substringToIndex:[[timeDict objectForKey:@"time_limit"] rangeOfString:@" "].location] floatValue]*60*60];
                            }
                            NSLog(@"finalStartDate %@ finalEndDate %@",startDate,endDate);
                            
                            event.startDate = [[NSDate alloc] initWithTimeInterval:0 sinceDate:startDate];
                            //                                event.startDate = strtDate;
                            event.endDate = endDate;
                            event.title = @"Appointment";
                            
                            event.notes = [NSString stringWithFormat:@"Your appointment will start on %@",event.startDate];
                            NSError *error = nil;
                            BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
                            if (result) {
                                NSLog(@"Saved event to event store.");
                            }
                            
                            NSError *err;
                            if(err)
                                NSLog(@"unable to save event to the calendar!: Error= %@", err);
                        }
                    }];
                }
            }
        }
    }
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
