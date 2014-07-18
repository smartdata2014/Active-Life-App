//
//  CreateEventViewController.h
//  Active Life App
//
//  Created by sdnmacmini10 on 23/06/14.
//  Copyright (c) 2014 sdnmacmini10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface CreateEventViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate>


@property(nonatomic, strong) NSString *eventStoreCalendarIdentifier;
@end
