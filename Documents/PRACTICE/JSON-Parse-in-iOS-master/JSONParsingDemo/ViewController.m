//
//  ViewController.m
//  JSONParsingDemo
//
//  Created by Krupa-iMac on 15/05/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

#import "ViewController.h"
#import "Colors.h"
#import "Colors+Creator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    marrAllColors = [[NSMutableArray alloc] init];
    
    [self parseJSONFile];
}

-(void)parseJSONFile
{
    //Creates and returns a data object by reading every byte from the file specified by a given path.
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Displaydata" ofType:@"json"]];
    
    //NSJSONSerialization is the class for converting JSON to Foundation objects and converting Foundation objects to JSON.
    //Top level objects must be NsArrays ,dictionary must have keys of type strings
    NSDictionary *dictTemp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
   // valueForKey: allows you to access a property using a string for its name.Which in this case is detailsArray
    NSArray *arrColors = [dictTemp valueForKey:@"detailsArray"];
    
   for (int i=0; i<arrColors.count; i++) {
        Colors *colors = [[Colors alloc] init];
        [colors parseResponse:[arrColors objectAtIndex:i]];
        [marrAllColors addObject:colors];
    }
    
    [self displayAllColros];
}

-(void)displayAllColros
{
    for (int i=0; i<marrAllColors.count; i++) {
        Colors *color = [marrAllColors objectAtIndex:i];
        NSLog(@"Color : name = %@ wallname = %@ start_date=%@ ",color.name,color.wallname,color.start_date);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
