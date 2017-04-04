//
//  Colors+Creator.m
//  JSONParsingDemo
//
//  Created by sameer purohit on 03/04/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

#import "Colors+Creator.h"

@implementation Colors (Creator)
- (void)parseResponse:(NSDictionary *)receivedObjects
{
    self.name = [receivedObjects objectForKey:@"name"];
    self.wallname = [receivedObjects objectForKey:@"wallname"];
    self.start_date=[receivedObjects objectForKey:@"start_date"];
}
@end
