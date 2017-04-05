//
//  DatabaseManager.h
//  RMS
//
//  Created by Sachendra.Rathore on 7/6/15.
//  Copyright (c) 2015 Yash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Employee.h"
#import "Project.h"
#import "Activity.h"
#import "TimeSheet.h"
#import "Global.h"

#define TABLE_EMPLOYEE @"Employee"
#define TABLE_PROJECT @"Project"
#define TABLE_ACTIVITY @"Activity"
#define TABLE_TIME_SHEET_ENTRY @"TimeSheetEntry"


@interface DatabaseManager : NSObject



//Insert
-(int)insertIntoEmployeeTableWithEmployee:(Employee *)employee;
-(int)insertIntoProjectTableWithProject:(Project *)project;
-(int)insertIntoActivityTableWithActivity:(Activity *)activity;
-(int)insertIntoTimeSheetEntryTableWithTimeSheet:(TimeSheet *)timesheet;

//Fetch
-(NSMutableArray *) fetchAllEmployeeTableData;
-(NSMutableArray *) fetchAllProjectTableData;
-(NSMutableArray *) fetchAllActivityTableData;
-(NSMutableArray *) fetchAllTimeSheetEntryTableData;

//fetch individually
- (NSMutableArray *) getTimeSheet_GroupBy_Week_Project:(double)EmpId;
- (Employee *) getEmployeeWithEmplyeeId:(double) EmpId;

- (NSMutableArray *) getProjectWithEmployeeId:(double) EmpId;
- (Project *) getProjectWithProjectId:(double)ProjectId andWithEmployeeId:(double)EmpId;
- (NSString *) getProjectNameWithProjectId:(double)ProjectId andWithEmpId:(double)EmpId;

- (NSMutableArray *) getTimeSheetWithEmployeeId:(double) EmpId;
- (NSMutableArray *) getTimeSheetWithEmployeeId:(double)EmpId andWithWeekEndDate:(NSDate *)WeekEndDate;
- (NSMutableArray *) getTimeSheetWithEmployeeId:(double)EmpId withProjectID:(double)ProjectId andWithWeekEndDate:(NSDate *)WeekEndDate;

- (NSMutableArray *) getActivityWithEmployeeId:(double) EmpId;
- (Activity *) getActivityWithEmployeeId:(double)EmpId andWithProjectId:(double)ProjectId;
- (NSMutableArray *) getActivityWithResourceAllocationID:(double)ResourceAllocationID;
- (Activity *) getActivityWithEmployeeId:(double)EmpId andWithActivityId:(NSString *)ActivityId;
- (NSString *) getActivityNameWithActivityId:(NSString *)ActivityId andWithEmpId:(double)EmpId;

//delete
- (BOOL)deleteFromtableName:(NSString *) tableName withEmplyeeId:(double)EmpId;
- (BOOL) deleteTimesheetWithEmployeeId:(double)EmpId withProjectID:(double)ProjectId withActivityId:(NSString *)activityId andWithWeekEndDate:(NSDate *)weekendDate;

+ (instancetype)sharedInstance;

@end
