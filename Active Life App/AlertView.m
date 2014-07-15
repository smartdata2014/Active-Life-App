//
//  AlertView.m
//  Beyond_Fitness
//
//  Created by sdnmacmini10 on 20/02/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

+(id)showAlertwithTitle: (NSString *)title message : (NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    return nil;
}

@end
