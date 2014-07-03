//
//  Helper.m
//  ValuePortal
//
//  Created by Gurdev Singh on 5/26/14.
//  Copyright (c) 2014 Gurdev Singh. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(NSDictionary *)ReadFromJSONStore:(NSString *)withStoreName
{
    NSString *json = [[NSString alloc]init];
    
    NSString *fileRoot = [[NSBundle mainBundle] pathForResource:withStoreName ofType:nil];
    json = [[NSString alloc]initWithContentsOfFile:fileRoot encoding:NSUTF8StringEncoding error:nil];
    id jsonResponse = nil;
    NSError *error;
    jsonResponse = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:fileRoot] options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"jsonResponse:%@",jsonResponse);
    NSDictionary *responseDict;
    responseDict = (NSDictionary *)jsonResponse;
    NSLog(@"responseDict:%@",jsonResponse);
    return responseDict;
}

@end
