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

@interface CreateEventViewController ()<SWRevealViewControllerDelegate>
{
    IBOutlet UISegmentedControl *segmentControl1, *segmentControl2;
    IBOutlet UITextField *txtName, *txtTime, *txtPlace, *txtActivity;
}

-(IBAction)btnActionSegmentControl1:(id)sender;
-(IBAction)btnActionSegmentControl2:(id)sender;
-(IBAction)btnMenuPressed:(id)sender;
-(IBAction)btnCreatePressed:(id)sender;

@property (nonatomic, strong) NSMutableDictionary *responseDict;
@end

@implementation CreateEventViewController
@synthesize eventStoreCalendarIdentifier;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    senderLabel.text = [NSString stringWithFormat:@"Facebook"];
    [cell.contentView addSubview:senderLabel];
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)btnActionSegmentControl1:(id)sender{
    if ([segmentControl1 selectedSegmentIndex]==0) {
        NSLog(@"Private");
        [_responseDict setObject:@"Private" forKey:@"Privacy"];
    }
    else if ([segmentControl1 selectedSegmentIndex]==1){
        NSLog(@"Public");
        [_responseDict setObject:@"Public" forKey:@"Privacy"];
    }
}

-(IBAction)btnActionSegmentControl2:(id)sender{
    if ([segmentControl2 selectedSegmentIndex]==0) {
        NSLog(@"Male");
        [_responseDict setObject:@"Male" forKey:@"Gender"];
    }
    else if ([segmentControl2 selectedSegmentIndex]==1){
        NSLog(@"Female");
        [_responseDict setObject:@"Female" forKey:@"Gender"];
    }
    else{
        NSLog(@"Both");
        [_responseDict setObject:@"Both" forKey:@"Gender"];
    }
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
    
//    NSDictionary *returnDict = [[WebserviceCall sharedInstance]callWebserviceWithIdentifier:@"GetAppointments" andArguments:postDict];
    
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
