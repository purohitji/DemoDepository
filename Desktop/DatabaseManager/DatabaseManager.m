//
//  DatabaseManager.m
//  RMS
//
//  Created by Sachendra.Rathore on 7/6/15.
//  Copyright (c) 2015 Yash. All rights reserved.
//

#import "DatabaseManager.h"



@implementation DatabaseManager

{
    sqlite3 *database;
    
    int dbResponse;
    NSFileManager *filemgr;
    NSString  *strDBPath;
    const char *charDBPath;
    
    NSMutableArray *arrColumnNames;
    NSMutableArray *arrResults;
    int  affectedRows;
    double lastInsertedRowID;
    // working!!

}

NSDateFormatter *dateFormatter ;


+ (instancetype)sharedInstance
{
    static DatabaseManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (sharedInstance==nil) {
            sharedInstance = [[DatabaseManager alloc] init];
            
            // Do any other initialisation stuff here
            
            //CreateTable here
            [sharedInstance createTables];
            [sharedInstance initDateFormatter];
        }
    });
    return sharedInstance;
}

-(void)initDateFormatter
{
    dateFormatter = [[NSDateFormatter alloc] init];
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZ"];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
}

-(BOOL)createTables
{
    
    filemgr = [NSFileManager defaultManager];
    
    //    if ([self createEmployeeTable]==SQLITE_OK ) {
    //    }
    
    [self createEmployeeTable];
    [self createProjectTable];
    [self createActivityTable];
    [self createTimeSheetEntryTable];
    
    return YES;
}

#pragma mark CreateTableMethods

-(int)createEmployeeTable
{
    database = NULL;
    dbResponse=-1;
    
    NSString *tableName=TABLE_EMPLOYEE;
    strDBPath =   [self getDbPathForTableName:tableName];
    
    if ([filemgr fileExistsAtPath: strDBPath ] == NO||[filemgr fileExistsAtPath: strDBPath ] == YES) {
        
        charDBPath = [strDBPath UTF8String];
        
        dbResponse = sqlite3_open_v2(charDBPath , &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
        
        if (SQLITE_OK != dbResponse)
        {
            sqlite3_close(database);
            NSLog(@"Failed to open database connection");
        }
        else
        {
            
            //NOT NULL DEFAULT ""
            //ON CONFLICT REPLACE // IGNORE
            //ON DUPLICATE KEY UPDATE tag=tag
           
            /*
             @property    double Id;
             @property    double YashEmpId;
             @property    double EmpId;
             @property    NSString *EmpFirstName;
             @property    NSString *EmpLastName;
             @property    NSString *UserName;
             @property    NSString *Password;
             */
            NSMutableString *query=[NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( id INTEGER PRIMARY KEY AUTOINCREMENT, YashEmpId INTEGER, EmpId INTEGER , EmpFirstName TEXT, EmpLastName TEXT,UserName TEXT, Password TEXT, UNIQUE(EmpId) ON CONFLICT IGNORE )",tableName];
            
            char * errMsg;
            dbResponse=sqlite3_exec(database, [query UTF8String],NULL,NULL,&errMsg);
            
            if(SQLITE_OK != dbResponse)
            {
                NSLog(@"Failed to create %@ rc: %d, msg= %s",tableName,dbResponse,errMsg);
            }
            sqlite3_close(database);
            
            return dbResponse;
            
        }
    }
    return dbResponse;
}
-(int)createProjectTable
{
    
    NSString *tableName=TABLE_PROJECT;
    
    database = NULL;
    dbResponse=-1;
    strDBPath =   [self getDbPathForTableName:tableName];
    
    if ([filemgr fileExistsAtPath: strDBPath ] == NO||[filemgr fileExistsAtPath: strDBPath ] == YES) {
        
        charDBPath = [strDBPath UTF8String];
        
        dbResponse = sqlite3_open_v2(charDBPath , &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
        
        if (SQLITE_OK != dbResponse)
        {
            sqlite3_close(database);
            NSLog(@"Failed to open database connection");
        }
        else
        {
            /*
             @property    double EmpId;
             @property    double ResourceAllocationID;
             @property    double ProjectId;
             @property    NSString *ProjectName;
             */
            
            //NOT NULL DEFAULT ""
            //changed primary key  PRIMARY KEY (column1, column2)
            NSMutableString *query=[NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( EmpId INTEGER, ResourceAllocationID INTEGER, ProjectId INTEGER , ProjectName TEXT,PRIMARY KEY (EmpId, ProjectId) , FOREIGN KEY (EmpId) REFERENCES Employee(EmpId))",tableName];
            
            //ALTER TABLE A ADD FOREIGN KEY B_ID B(ID)
            // ALTER TABLE B ADD FOREIGN KEY A_ID A(ID)
           
            /*CREATE TABLE child (
             id           INTEGER PRIMARY KEY,
             parent_id    INTEGER,
             description  TEXT,
             FOREIGN KEY (parent_id) REFERENCES parent(id)
             );*/
            //FOREIGN KEY (parent_id) REFERENCES parent(id)
            
            char * errMsg;
            dbResponse=sqlite3_exec(database, [query UTF8String],NULL,NULL,&errMsg);
            
            if(SQLITE_OK != dbResponse)
            {
                NSLog(@"Failed to create %@ rc: %d, msg= %s",tableName,dbResponse,errMsg);
            }
            sqlite3_close(database);
            
            return dbResponse;
            
        }
    }
    return dbResponse;
}
-(int)createActivityTable
{
    
    
    NSString *tableName=TABLE_ACTIVITY;
    
    database = NULL;
    dbResponse=-1;
    strDBPath =   [self getDbPathForTableName:tableName];
    
    
    
    if ([filemgr fileExistsAtPath: strDBPath ] == NO||[filemgr fileExistsAtPath: strDBPath ] == YES) {
        
        charDBPath = [strDBPath UTF8String];
        
        dbResponse = sqlite3_open_v2(charDBPath , &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
        
        if (SQLITE_OK != dbResponse)
        {
            sqlite3_close(database);
            NSLog(@"Failed to open database connection");
        }
        else
        {
            
            /*
             @property double EmpId;
             @property double ActivityId;
             @property double ProjectId;
             @property double ResourceAllocationID;
             @property NSString* ActivityName;
             */
          //  changing primary key ResourceAllocationID INTEGER PRIMARY KEY PRIMARY KEY (column1, column2)
            NSMutableString *query=[NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( EmpId INTEGER,ActivityId TEXT, ProjectId INTEGER , ResourceAllocationID INTEGER , ActivityName TEXT, PRIMARY KEY (ActivityId, EmpId), FOREIGN KEY (EmpId) REFERENCES Employee(EmpId))",tableName];
            
            char * errMsg;
            dbResponse=sqlite3_exec(database, [query UTF8String],NULL,NULL,&errMsg);
            
            if(SQLITE_OK != dbResponse)
            {
                NSLog(@"Failed to create %@ rc: %d, msg= %s",tableName,dbResponse,errMsg);
            }
            sqlite3_close(database);
            
            return dbResponse;
            
        }
    }
    return dbResponse;
}

-(int)createTimeSheetEntryTable
{
    
    ////   TimeSheet
    //    @property NSInteger *ApprvedStatus;
    //
    //    @property NSInteger *SyncStatus;
    //
    //    @property NSDate *EntryDate;
    //    @property NSDate *ApprovalDate;
    //    @property NSString *Module;
    //    @property NSDate *WeekStartDate;
    //    @property NSDate *WeekEndDate;
    //
    //
    //    @property double Day1_WH;
    //    @property double Day2_WH;
    //    @property double Day3_WH;
    //    @property double Day4_WH;
    //    @property double Day5_WH;
    //    @property double Day6_WH;
    //    @property double Day7_WH;
    //
    //    @property NSString *Day1_Description;
    //    @property NSString *Day2_Description;
    //    @property NSString *Day3_Description;
    //    @property NSString *Day4_Description;
    //    @property NSString *Day5_Description;
    //    @property NSString *Day6_Description;
    //    @property NSString *Day7_Description;
    
    
    
    NSString *tableName=TABLE_TIME_SHEET_ENTRY;
    
    
    
    
    
    database = NULL;
    dbResponse=-1;
    strDBPath =   [self getDbPathForTableName:tableName];
    
    
    
    if ([filemgr fileExistsAtPath: strDBPath ] == NO||[filemgr fileExistsAtPath: strDBPath ] == YES) {
        
        charDBPath = [strDBPath UTF8String];
        
        dbResponse = sqlite3_open_v2(charDBPath , &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
        
        if (SQLITE_OK != dbResponse)
        {
            sqlite3_close(database);
            NSLog(@"Failed to open database connection");
        }
        else
        {
            
            //NOT NULL DEFAULT ""
            NSMutableString *query=[NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( id INTEGER PRIMARY KEY AUTOINCREMENT, EmpId INTEGER, ResourceAllocationID INTEGER, ProjectId INTEGER,ActivityId TEXT, ApprvedStatus INTEGER, SyncStatus INTEGER, EntryDate DATE, ApprovalDate DATE, Module TEXT, WeekStartDate DATE, WeekEndDate DATE, Day1_WH INTEGER, Day2_WH INTEGER, Day3_WH INTEGER, Day4_WH INTEGER, Day5_WH INTEGER, Day6_WH INTEGER, Day7_WH INTEGER, Day1_Description TEXT, Day2_Description TEXT, Day3_Description TEXT, Day4_Description TEXT, Day5_Description TEXT, Day6_Description TEXT, Day7_Description TEXT, TotalOfWeekHours INTEGER, TempTotalOfWeekHours INTEGER, FOREIGN KEY (EmpId) REFERENCES Employee(EmpId), FOREIGN KEY (ProjectId) REFERENCES Project(ProjectId), FOREIGN KEY (ProjectId) REFERENCES Project(ProjectId), FOREIGN KEY (ActivityId) REFERENCES Activity(ActivityId))",tableName];
            
            
            char * errMsg;
            dbResponse=sqlite3_exec(database, [query UTF8String],NULL,NULL,&errMsg);
            
            if(SQLITE_OK != dbResponse)
            {
                NSLog(@"Failed to create %@ rc: %d, msg= %s",tableName,dbResponse,errMsg);
            }
            sqlite3_close(database);
            
            return dbResponse;
            
        }
    }
    return dbResponse;
}
#pragma mark InsertInToTableMethods

-(int)insertIntoEmployeeTableWithEmployee:(Employee *)employee
{
    
    
    NSString * query ;
    NSString *tableName=@"Employee";
    char * errMsg;
    
    
    dbResponse = sqlite3_open_v2([[self getDbPathForTableName:tableName] cStringUsingEncoding:NSUTF8StringEncoding], &database, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != dbResponse)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open db connection for %@ ",tableName);
    }
    else
        
    {

        /*
         @property    double Id;
         @property    double YashEmpId;
         @property    double EmpId;
         @property    NSString *EmpFirstName;
         @property    NSString *EmpLastName;
         @property    NSString *UserName;
         @property    NSString *Password;
         */
        query= [NSString
                stringWithFormat:@"INSERT INTO Employee (id,YashEmpId,EmpId,EmpFirstName,EmpLastName,Username,Password) VALUES (null,\"%.0f\",\"%.0f\",\"%@\",\"%@\",\"%@\",\"%@\");",employee.YashEmpId,employee.EmpId,employee.EmpFirstName,employee.EmpLastName,employee.UserName,employee.Password];
        
        // NSLog(@"query %@",query);
        dbResponse = sqlite3_exec(database, [query UTF8String] ,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != dbResponse)
        {
            NSLog(@"In %@ Failed to insert record   rc:%d, msg=%s",tableName,dbResponse,errMsg);
        }
        
    }
    
    sqlite3_close(database);
    
    return dbResponse;
}

-(int)insertIntoProjectTableWithProject:(Project *)project
{
    
    
    NSString * query ;
    NSString *tableName=@"Project";
    char * errMsg;
    
    
    dbResponse = sqlite3_open_v2([[self getDbPathForTableName:tableName] cStringUsingEncoding:NSUTF8StringEncoding], &database, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != dbResponse)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open db connection for %@ ",tableName);
    }
    else
        
    {
        /*
         @property    double EmpId;
         @property    double ResourceAllocationID;
         @property    double ProjectId;
         @property    NSString *ProjectName;
         */
        
        query= [NSString
                stringWithFormat:@"INSERT INTO Project (EmpId,ResourceAllocationID,ProjectId,ProjectName) VALUES (\"%f\",\"%f\",\"%f\",\"%@\");",project.EmpId,project.ResourceAllocationID,project.ProjectId,project.ProjectName];
        
        // NSLog(@"query %@",query);
        dbResponse  =  sqlite3_exec(database, [query UTF8String] ,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != dbResponse)
        {
            NSLog(@"In %@ Failed to insert record   rc:%d, msg=%s",tableName,dbResponse,errMsg);
        }
        
    }
    
    sqlite3_close(database);
    
    return dbResponse;
}

-(int)insertIntoActivityTableWithActivity:(Activity *)activity
{
    
    
    NSString * query ;
    NSString *tableName=@"Activity";
    char * errMsg;
    
    
    dbResponse = sqlite3_open_v2([[self getDbPathForTableName:tableName] cStringUsingEncoding:NSUTF8StringEncoding], &database, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != dbResponse)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open db connection for %@ ",tableName);
    }
    else
        
    {
        /*
         @property double EmpId;
         @property double ActivityId;
         @property double ProjectId;
         @property double ResourceAllocationID;
         @property NSString* ActivityName;
         */
        NSLog(@"input activity %@",activity);
        query= [NSString
                stringWithFormat:@"INSERT INTO Activity (EmpId,ActivityId,ProjectId,ResourceAllocationID,ActivityName) VALUES (\"%.0f\",\"%@\",\"%.0f\",\"%.0f\",\"%@\");",activity.EmpId, activity.ActivityId,activity.ProjectId,activity.ResourceAllocationID,activity.ActivityName];
        
        // NSLog(@"query %@",query);
        dbResponse = sqlite3_exec(database, [query UTF8String] ,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != dbResponse)
        {
            NSLog(@"In %@ Failed to insert record   rc:%d, msg=%s",tableName,dbResponse,errMsg);
        }
        
    }
    
    sqlite3_close(database);
    
    return dbResponse;
}

-(int)insertIntoTimeSheetEntryTableWithTimeSheet:(TimeSheet *)timesheet
{
    
    
    NSString * query ;
    NSString *tableName=@"TimeSheetEntry";
    char * errMsg;
    sqlite3_stmt *sqlStatement=NULL;
    BOOL success=NO;
    
    dbResponse = sqlite3_open_v2([[self getDbPathForTableName:tableName] cStringUsingEncoding:NSUTF8StringEncoding], &database, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != dbResponse)
    {
        sqlite3_close(database);
        NSLog(@"Failed to open db connection for %@ ",tableName);
    }
    else
    {
        
        if (timesheet.Id > 0.0) {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE TimeSheetEntry set ResourceAllocationId =\"%f\", ProjectId=\"%f\", ActivityId=\"%@\", ApprvedStatus=\"%f\", SyncStatus=\"%f\", EntryDate=\"%@\", ApprovalDate=\"%@\", Module=\"%@\", WeekStartDate=\"%@\", WeekEndDate=\"%@\", Day1_WH=\"%f\", Day2_WH=\"%f\", Day3_WH=\"%f\", Day4_WH=\"%f\", Day5_WH=\"%f\", Day6_WH=\"%f\", Day7_WH=\"%f\", Day1_Description=\"%@\", Day2_Description=\"%@\", Day3_Description=\"%@\", Day4_Description=\"%@\", Day5_Description=\"%@\", Day6_Description=\"%@\", Day7_Description=\"%@\",TotalOfWeekHours=\"%f\",TempTotalOfWeekHours=\"%f\" WHERE id =\"%.0f\";",timesheet.ResourceAllocationId, timesheet.ProjectId, timesheet.ActivityId, timesheet.ApprvedStatus, timesheet.SyncStatus, [Global toUtcDateTime:timesheet.EntryDate], [Global toUtcDateTime:timesheet.ApprovalDate], timesheet.Module, [Global toUtcDateTime:timesheet.WeekStartDate], [Global toUtcDateTime:timesheet.WeekEndDate], timesheet.Day1_WH, timesheet.Day2_WH, timesheet.Day3_WH, timesheet.Day4_WH, timesheet.Day5_WH, timesheet.Day6_WH, timesheet.Day7_WH, timesheet.Day1_Description, timesheet.Day2_Description, timesheet.Day3_Description, timesheet.Day4_Description, timesheet.Day5_Description, timesheet.Day6_Description, timesheet.Day7_Description,timesheet.TotalOfWeekHours,timesheet.TempTotalOfWeekHours,timesheet.Id];
            
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(database, update_stmt, -1, &sqlStatement, NULL );
            sqlite3_bind_int(sqlStatement, 1, timesheet.Id);
            
            if (sqlite3_step(sqlStatement) == SQLITE_DONE)
            {
                success = YES;
            }
            
        }
        else{
        
        query= [NSString
                stringWithFormat:@"INSERT INTO TimeSheetEntry (id, EmpId, ResourceAllocationId, ProjectId, ActivityId, ApprvedStatus, SyncStatus, EntryDate, ApprovalDate, Module, WeekStartDate, WeekEndDate, Day1_WH, Day2_WH, Day3_WH, Day4_WH, Day5_WH, Day6_WH, Day7_WH, Day1_Description, Day2_Description, Day3_Description, Day4_Description, Day5_Description, Day6_Description, Day7_Description,TotalOfWeekHours,TempTotalOfWeekHours) VALUES (null,\"%f\",\"%f\",\"%f\",\"%@\",\"%f\",\"%f\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%f\",\"%f\",\"%f\",\"%f\",\"%f\",\"%f\",\"%f\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%f\",\"%f\");", timesheet.EmpId, timesheet.ResourceAllocationId, timesheet.ProjectId, timesheet.ActivityId, timesheet.ApprvedStatus, timesheet.SyncStatus, [Global toUtcDateTime:timesheet.EntryDate], [Global toUtcDateTime:timesheet.ApprovalDate], timesheet.Module, [Global toUtcDateTime:timesheet.WeekStartDate], [Global toUtcDateTime:timesheet.WeekEndDate], timesheet.Day1_WH, timesheet.Day2_WH, timesheet.Day3_WH, timesheet.Day4_WH, timesheet.Day5_WH, timesheet.Day6_WH, timesheet.Day7_WH, timesheet.Day1_Description, timesheet.Day2_Description, timesheet.Day3_Description, timesheet.Day4_Description, timesheet.Day5_Description, timesheet.Day6_Description, timesheet.Day7_Description,timesheet.TotalOfWeekHours,timesheet.TempTotalOfWeekHours];
        
        
        // NSLog(@"query %@",query);
        dbResponse = sqlite3_exec(database, [query UTF8String] ,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != dbResponse)
        {
            NSLog(@"In %@ Failed to insert record   rc:%d, msg=%s",tableName,dbResponse,errMsg);
        }
        }
    }
    
    sqlite3_close(database);
    
    return dbResponse;
}

#pragma mark FetchFromTableMethods

-(NSMutableArray *) fetchAllEmployeeTableData
{
    NSMutableArray *arrEmployee = [[NSMutableArray alloc] init];
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Employee";
    
    @try {
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query=[NSString stringWithFormat:@"SELECT * from %@",tableName];
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            Employee *employee=[[Employee alloc]init];
            
            /*
             @property    double Id;
             @property    double YashEmpId;
             @property    double EmpId;
             @property    NSString *EmpFirstName;
             @property    NSString *EmpLastName;
             @property    NSString *UserName;
             @property    NSString *Password;
             */
            
            employee.Id = (double)sqlite3_column_double(sqlStatement, 0);
            employee.YashEmpId=(double)sqlite3_column_double(sqlStatement, 1);
            employee.EmpId=(double)sqlite3_column_double(sqlStatement, 2);
            employee.EmpFirstName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,3)];
            employee.EmpLastName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
            employee.UserName= [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,5)];
            employee.Password= [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,6)];
            
            [arrEmployee addObject:employee];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Employee : %@", [exception reason]);
    }
    @finally {
        return arrEmployee;
    }
    
    return [[NSMutableArray alloc]init];
}

//get information about a specfic employee by it's id
- (Employee *) getEmployeeWithEmplyeeId:(double) EmpId
{
 
    Employee *employee;
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    NSString *tableName=@"Employee";
    
    @try {

        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
    //SELECT id, name, department, age FROM EMPLOYEES WHERE id=%d
        query= [NSString stringWithFormat:
                              @"SELECT * FROM %@ WHERE EmpId=%.0f",tableName,
                              EmpId];
    
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        /*if (sqlite3_prepare_v2(mySqliteDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
         {
         sqlite3_finalize(statement);
         }*/
        
    if(sqlite3_step(sqlStatement) == SQLITE_ROW)
            {
                /*
                 @property    double Id;
                 @property    double YashEmpId;
                 @property    double EmpId;
                 @property    NSString *EmpFirstName;
                 @property    NSString *EmpLastName;
                 @property    NSString *UserName;
                 @property    NSString *Password;
                 */
                employee = [[Employee alloc] init];
                employee.Id = (double)sqlite3_column_double(sqlStatement, 0);
                employee.YashEmpId=(double)sqlite3_column_double(sqlStatement, 1);
                employee.EmpId=EmpId;
                employee.EmpFirstName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,3)];
                employee.EmpLastName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
                employee.UserName= [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,5)];
                employee.Password= [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,6)];
            }
            sqlite3_finalize(sqlStatement);
    
        sqlite3_close(database);
    }
        @catch (NSException *exception) {
            NSLog(@"An exception occured Employee : %@", [exception reason]);
        }
        @finally {
            return employee;
        }
}

#pragma mark PROJECT
-(NSMutableArray *) fetchAllProjectTableData
{
    NSMutableArray *arrProject = [[NSMutableArray alloc] init];
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Project";
    
    @try {
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query=[NSString stringWithFormat:@"SELECT * from %@",tableName];
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        
        if (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            Project *project=[[Project alloc]init];
            
            /*
             @property    double EmpId;
             @property    double ResourceAllocationID;
             @property    double ProjectId;
             @property    NSString *ProjectName;
             */
            
            project.EmpId = (double)sqlite3_column_double(sqlStatement, 0);
            project.ResourceAllocationID = (double)sqlite3_column_double(sqlStatement, 1);
            project.ProjectId = (double)sqlite3_column_double(sqlStatement, 2);
            
            //NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            //const unsigned char *p1=sqlite3_column_text(sqlStatement, 1);
            //NSLog(@"%s",p1);
            //project.EmpFirstName = [NSString stringWithUTF8String:(const char*)p1];
            
            project.ProjectName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,3)];
            
            
            [arrProject addObject:project];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Project: %@", [exception reason]);
    }
    @finally {
        return arrProject;
    }
    
    return [[NSMutableArray alloc]init];
}

//get information about a specfic Project by Employee's id
- (NSMutableArray *) getProjectWithEmployeeId:(double)EmpId
{
    NSMutableArray *arrProject = [[NSMutableArray alloc] init];
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Project";
    
    @try {
        
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE EmpId = %.0f",tableName,
                EmpId];
        
       // NSLog(@"Project getbyEmpId query  %@",query);
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        while(sqlite3_step(sqlStatement) == SQLITE_ROW)
        {

            Project *project=[[Project alloc]init];
            
            /*
             @property    double EmpId;
             @property    double ResourceAllocationID;
             @property    double ProjectId;
             @property    NSString *ProjectName;
             */
            
            project.EmpId = EmpId;
            project.ResourceAllocationID = (double)sqlite3_column_double(sqlStatement, 1);
            project.ProjectId = (double)sqlite3_column_double(sqlStatement, 2);
            project.ProjectName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,3)];
            
            
            [arrProject addObject:project];

            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Project : %@", [exception reason]);
    }
    @finally {
        return arrProject;
    }
}

- (Project *) getProjectWithProjectId:(double)ProjectId andWithEmployeeId:(double)EmpId
{
    Project *project = [[Project alloc] init];
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Project";
    
    @try {
        
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE ProjectId = %.0f AND EmpId = %.0f",tableName,
                ProjectId,EmpId];
        
        // NSLog(@"Project getbyEmpId query  %@",query);
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        // assuming there will be only one proj for empid and proj id pair
        if(sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            /*
             @property    double EmpId;
             @property    double ResourceAllocationID;
             @property    double ProjectId;
             @property    NSString *ProjectName;
             */
            
            project.EmpId = (double)sqlite3_column_double(sqlStatement, 0);
            project.ResourceAllocationID = (double)sqlite3_column_double(sqlStatement, 1);
            project.ProjectId = ProjectId;
            project.ProjectName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,3)];
            

        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Project : %@", [exception reason]);
    }
    @finally {
        return project;
    }
}


//get information about a specfic Project by Projects's id
- (NSString *) getProjectNameWithProjectId:(double)ProjectId andWithEmpId:(double)EmpId
{
    NSString *projectName;
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Project";
    
    @try {
        
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE ProjectId =%.0f AND EmpId=%.0f",tableName,
                ProjectId,EmpId];
        
        // NSLog(@"Project getbyEmpId query  %@",query);
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        while(sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            
           // Project *project=[[Project alloc]init];
            
            /*
             @property    double EmpId;
             @property    double ResourceAllocationID;
             @property    double ProjectId;
             @property    NSString *ProjectName;
             */
            
//            project.EmpId = (double)sqlite3_column_double(sqlStatement, 0);
//            project.ResourceAllocationID = (double)sqlite3_column_double(sqlStatement, 1);
//            project.ProjectId = (double)sqlite3_column_double(sqlStatement, 2);
//            project.ProjectName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,3)];
            
            projectName=[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,3)];
            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured project : %@", [exception reason]);
    }
    @finally {
        return projectName ;
    }
}
#pragma mark ACTIVITY
-(NSMutableArray *) fetchAllActivityTableData
{
    NSMutableArray *arrActivity = [[NSMutableArray alloc] init];
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Activity";
    
    @try {
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query=[NSString stringWithFormat:@"SELECT * from %@",tableName];
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            Activity *activity=[[Activity alloc]init];
            
            /*
             @property double EmpId;
             @property double ActivityId;
             @property double ProjectId;
             @property double ResourceAllocationID;
             @property NSString* ActivityName;
             */
            
            activity.EmpId = (double)sqlite3_column_double(sqlStatement, 0);
            activity.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            activity.ProjectId = (double)sqlite3_column_double(sqlStatement, 2);
            activity.ResourceAllocationID = (double)sqlite3_column_double(sqlStatement, 3);
            activity.ActivityName  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
            
            
            [arrActivity addObject:activity];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Activity: %@", [exception reason]);
    }
    @finally {
        return arrActivity;
    }
    
    return [[NSMutableArray alloc]init];
}

//get Activities By EmpId

- (NSMutableArray *) getActivityWithEmployeeId:(double)EmpId
{
    NSMutableArray *arrActivities = [[NSMutableArray alloc] init];
    
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Activity";
    
    @try {
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE EmpId=%.0f",tableName,
                EmpId];
        
//        NSLog(@"Activity getbyEmpId query  %@",query);
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        while(sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            
            Activity *activity=[[Activity alloc]init];
            
            /*
             @property double EmpId;
             @property double ActivityId;
             @property double ProjectId;
             @property double ResourceAllocationID;
             @property NSString* ActivityName;
             */
            
            activity.EmpId = (double)sqlite3_column_double(sqlStatement, 0);
            activity.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            activity.ProjectId = (double)sqlite3_column_double(sqlStatement, 2);
            activity.ResourceAllocationID = (double)sqlite3_column_double(sqlStatement, 3);
            activity.ActivityName  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
            
            [arrActivities addObject:activity];
            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Activity : %@", [exception reason]);
    }
    @finally {
        return arrActivities;
    }
}


- (NSMutableArray *) getActivityWithResourceAllocationID:(double)ResourceAllocationID
{
    NSMutableArray *arrActivities = [[NSMutableArray alloc] init];
    
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Activity";
    
    @try {
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE ResourceAllocationID=%.0f",tableName,
                ResourceAllocationID];
        
        //        NSLog(@"Activity getbyEmpId query  %@",query);
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        while(sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            
            Activity *activity=[[Activity alloc]init];
            
            /*
             @property double EmpId;
             @property double ActivityId;
             @property double ProjectId;
             @property double ResourceAllocationID;
             @property NSString* ActivityName;
             */
            
            activity.EmpId = (double)sqlite3_column_double(sqlStatement, 0);
            activity.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            activity.ProjectId = (double)sqlite3_column_double(sqlStatement, 2);
            activity.ResourceAllocationID = (double)sqlite3_column_double(sqlStatement, 3);
            activity.ActivityName  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
            
            [arrActivities addObject:activity];
            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Activity : %@", [exception reason]);
    }
    @finally {
        return arrActivities;
    }
}

- (Activity *) getActivityWithEmployeeId:(double)EmpId andWithProjectId:(double)ProjectId
{
    Activity *activity = [[Activity alloc] init];
    
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Activity";
    
    @try {
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE EmpId=%.0f AND ProjectId=%.0f",tableName,
                EmpId,ProjectId];
        
        //        NSLog(@"Activity getbyEmpId query  %@",query);
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        while(sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            /*
             @property double EmpId;
             @property double ActivityId;
             @property double ProjectId;
             @property double ResourceAllocationID;
             @property NSString* ActivityName;
             */
            
            activity.EmpId = (double)sqlite3_column_double(sqlStatement, 0);
            activity.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];;
            activity.ProjectId = (double)sqlite3_column_double(sqlStatement, 2);
            activity.ResourceAllocationID = (double)sqlite3_column_double(sqlStatement, 3);
            activity.ActivityName  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
            
            
            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Activity : %@", [exception reason]);
    }
    @finally {
        return activity;
    }
}

- (Activity *) getActivityWithEmployeeId:(double)EmpId andWithActivityId:(NSString *)ActivityId
{
    Activity *activity = [[Activity alloc] init];
    
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Activity";
    
    @try {
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE EmpId=%.0f AND ActivityId='%@'",tableName,
                EmpId,ActivityId];
        
        //        NSLog(@"Activity getbyEmpId query  %@",query);
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        while(sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            /*
             @property double EmpId;
             @property double ActivityId;
             @property double ProjectId;
             @property double ResourceAllocationID;
             @property NSString* ActivityName;
             */
            activity.EmpId = (double)sqlite3_column_double(sqlStatement, 0);
            activity.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];;
            activity.ProjectId = (double)sqlite3_column_double(sqlStatement, 2);
            activity.ResourceAllocationID = (double)sqlite3_column_double(sqlStatement, 3);
            activity.ActivityName  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Activity : %@", [exception reason]);
    }
    @finally {
        return activity;
    }
}

- (NSString *) getActivityNameWithActivityId:(NSString *)ActivityId andWithEmpId:(double)EmpId
{
    Activity *activity = [[Activity alloc] init];
    
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"Activity";
    
    @try {
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE EmpId=%.0f AND ActivityId='%@'",tableName,
                EmpId,ActivityId];
        
        //        NSLog(@"Activity getbyEmpId query  %@",query);
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        if(sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            /*
             @property double EmpId;
             @property double ActivityId;
             @property double ProjectId;
             @property double ResourceAllocationID;
             @property NSString* ActivityName;
             */
//            activity.EmpId = (double)sqlite3_column_double(sqlStatement, 0);
//            activity.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];;
//            activity.ProjectId = (double)sqlite3_column_double(sqlStatement, 2);
//            activity.ResourceAllocationID = (double)sqlite3_column_double(sqlStatement, 3);
            activity.ActivityName  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Activity : %@", [exception reason]);
    }
    @finally {
        return activity.ActivityName;
    }
}


#pragma mark TIMESHEET
-(NSMutableArray *) fetchAllTimeSheetEntryTableData
{
    NSMutableArray *arrTimeSheet = [[NSMutableArray alloc] init];
    NSString *query;

    sqlite3_stmt *sqlStatement=NULL;

    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
    
    /*
     utc
     Input Db format  : 2015-07-29 11:49:52 +0000
     OutPut Db format : 2015-07-29 11:32:17 +0000
     so fromat "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
     yyyy-MM-dd'T'HH:mm:ssZZZ
     */
    
    NSString *tableName=TABLE_TIME_SHEET_ENTRY;
    
    @try {
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query=[NSString stringWithFormat:@"SELECT * from %@",tableName];
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            
            TimeSheet *timeSheet=[[TimeSheet alloc]init];
            
            
            /*
             @property double EmpId;
             @property double ActivityId;
             @property NSString* ActivityName;
             */
            
            timeSheet.Id = (double)sqlite3_column_double(sqlStatement, 0);
            timeSheet.EmpId = (double)sqlite3_column_double(sqlStatement, 1);
            timeSheet.ResourceAllocationId = (double)sqlite3_column_double(sqlStatement, 2);
            timeSheet.ProjectId = (double)sqlite3_column_double(sqlStatement, 3);
            timeSheet.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];;
            timeSheet.ApprvedStatus = (double)sqlite3_column_double(sqlStatement, 5);
            timeSheet.SyncStatus = (double)sqlite3_column_double(sqlStatement, 6);
            
            timeSheet.EntryDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,7)]];
            timeSheet.ApprovalDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,8)]];
            
            timeSheet.Module  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,9)];
            
            timeSheet.WeekStartDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,10)]];
            timeSheet.WeekEndDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,11)]];
            
            NSMutableString *weekenddate =  [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,11)];
            
            timeSheet.Day1_WH = (double)sqlite3_column_double(sqlStatement, 12);
            timeSheet.Day2_WH = (double)sqlite3_column_double(sqlStatement, 13);
            timeSheet.Day3_WH = (double)sqlite3_column_double(sqlStatement, 14);
            timeSheet.Day4_WH = (double)sqlite3_column_double(sqlStatement, 15);
            timeSheet.Day5_WH = (double)sqlite3_column_double(sqlStatement, 16);
            timeSheet.Day6_WH = (double)sqlite3_column_double(sqlStatement, 17);
            timeSheet.Day7_WH = (double)sqlite3_column_double(sqlStatement, 18);
            
            timeSheet.Day1_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,19)];
            timeSheet.Day2_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,20)];
            timeSheet.Day3_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,21)];
            timeSheet.Day4_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,22)];
            timeSheet.Day5_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,23)];
            timeSheet.Day6_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,24)];
            timeSheet.Day7_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,25)];
            
            

            
            [arrTimeSheet addObject:timeSheet];
     
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured timesheet: %@", [exception reason]);
    }
    @finally {
        return arrTimeSheet;
    }
    
    return [[NSMutableArray alloc]init];
}

- (NSMutableArray *) getTimeSheet_GroupBy_Week_Project:(double)EmpId{
    
    NSMutableArray *arrTimeSheet = [[NSMutableArray alloc] init];
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"TimeSheetEntry";
    
    @try {
        
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        NSLog(@"strDBPath  %@",strDBPath);
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
//        query= [NSString stringWithFormat:
//                @"SELECT ProjectId, WeekEndDate, sum(TotalOfWeekHours) as TempColumn FROM %@ WHERE EmpId=%.0f GROUP BY WeekEndDate,ProjectId ORDER BY WeekEndDate",tableName,
//                EmpId];
        
        /*
         @property double Id;
         @property double EmpId;
         @property double ResourceAllocationId;
         @property double ProjectId;
         @property double ActivityId;
         
         @property double ApprvedStatus;
         
         @property double SyncStatus;
         
         @property NSDate *EntryDate;
         @property NSDate *ApprovalDate;
         @property NSString *Module;
         @property NSDate *WeekStartDate;
         @property NSDate *WeekEndDate;
         
         
         @property double Day1_WH;
         @property double Day2_WH;
         @property double Day3_WH;
         @property double Day4_WH;
         @property double Day5_WH;
         @property double Day6_WH;
         @property double Day7_WH;
         
         @property double TotalOfWeekHours;
         @property double TempTotalOfWeekHours;
         
         @property NSString *Day1_Description;
         @property NSString *Day2_Description;
         @property NSString *Day3_Description;
         @property NSString *Day4_Description;
         @property NSString *Day5_Description;
         @property NSString *Day6_Description;
         @property NSString *Day7_Description;
         
         */
        
                query= [NSString stringWithFormat:
                        @"SELECT TimeSheetEntry.Id, TimeSheetEntry.EmpId, TimeSheetEntry.ResourceAllocationId, TimeSheetEntry.ProjectId, TimeSheetEntry.ActivityId, TimeSheetEntry.ApprvedStatus,TimeSheetEntry.SyncStatus, TimeSheetEntry.EntryDate, TimeSheetEntry.ApprovalDate, TimeSheetEntry.Module, TimeSheetEntry.WeekStartDate, TimeSheetEntry.WeekEndDate, TimeSheetEntry.Day1_WH, TimeSheetEntry.Day2_WH, TimeSheetEntry.Day3_WH, TimeSheetEntry.Day4_WH, TimeSheetEntry.Day5_WH, TimeSheetEntry.Day6_WH, TimeSheetEntry.Day7_WH, TimeSheetEntry.Day1_Description, TimeSheetEntry.Day2_Description, TimeSheetEntry.Day3_Description, TimeSheetEntry.Day4_Description, TimeSheetEntry.Day5_Description, TimeSheetEntry.Day6_Description, TimeSheetEntry.Day7_Description, TimeSheetEntry.TotalOfWeekHours, TimeSheetEntry.TempTotalOfWeekHours, sum(TimeSheetEntry.TotalOfWeekHours) as TempColumn, ProjectName FROM (TimeSheetEntry INNER JOIN Project ON TimeSheetEntry.ProjectId=Project.ProjectId) WHERE TimeSheetEntry.EmpId=%.0f GROUP BY TimeSheetEntry.WeekEndDate, TimeSheetEntry.ProjectId ORDER BY TimeSheetEntry.WeekEndDate",
                        EmpId];
        
        
        //[ORDER BY column1, column2, .. columnN] [ASC. DESC]
        // NSLog(@"TimeSheet getbyEmpId query  %@",query);
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        while (sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            /*
             @property    double EmpId;
             @property    double ResourceAllocationID;
             @property    double ProjectId;
             @property    NSString *ProjectName;
             */
            
            TimeSheet *timeSheet=[[TimeSheet alloc]init];
            
            timeSheet.Id = (double)sqlite3_column_double(sqlStatement, 0);
            timeSheet.EmpId = (double)sqlite3_column_double(sqlStatement, 1);
            timeSheet.ResourceAllocationId = (double)sqlite3_column_double(sqlStatement, 2);
            timeSheet.ProjectId = (double)sqlite3_column_double(sqlStatement, 3);
            timeSheet.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];;
            timeSheet.ApprvedStatus = (double)sqlite3_column_double(sqlStatement, 5);
            timeSheet.SyncStatus = (double)sqlite3_column_double(sqlStatement, 6);
            
            timeSheet.EntryDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,7)]];
            timeSheet.ApprovalDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,8)]];
            
            timeSheet.Module  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,9)];
            
            timeSheet.WeekStartDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,10)]];
            
            timeSheet.WeekEndDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,11)]];
            
            NSMutableString *weekenddate =  [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,11)];
            timeSheet.Day1_WH = (double)sqlite3_column_double(sqlStatement, 12);
            timeSheet.Day2_WH = (double)sqlite3_column_double(sqlStatement, 13);
            timeSheet.Day3_WH = (double)sqlite3_column_double(sqlStatement, 14);
            timeSheet.Day4_WH = (double)sqlite3_column_double(sqlStatement, 15);
            timeSheet.Day5_WH = (double)sqlite3_column_double(sqlStatement, 16);
            timeSheet.Day6_WH = (double)sqlite3_column_double(sqlStatement, 17);
            timeSheet.Day7_WH = (double)sqlite3_column_double(sqlStatement, 18);
            
            timeSheet.Day1_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,19)];
            timeSheet.Day2_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,20)];
            timeSheet.Day3_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,21)];
            timeSheet.Day4_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,22)];
            timeSheet.Day5_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,23)];
            timeSheet.Day6_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,24)];
            timeSheet.Day7_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,25)];
            
            timeSheet.TotalOfWeekHours = (double)sqlite3_column_double(sqlStatement, 26);
            timeSheet.TempTotalOfWeekHours = (double)sqlite3_column_double(sqlStatement, 27);
//            as TempColumn 28
            timeSheet.ProjectName=[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,29)];
            
            [arrTimeSheet addObject:timeSheet];
            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Employee : %@", [exception reason]);
    }
    @finally {
        return arrTimeSheet;
    }
}

//get information about a specfic TimeSheet by Emplyee's id
- (NSMutableArray *) getTimeSheetWithEmployeeId:(double)EmpId{
    
    NSMutableArray *arrTimeSheet = [[NSMutableArray alloc] init];
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;

    NSString *tableName=@"TimeSheetEntry";
    
    @try {
        
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE EmpId=%.0f",tableName,
                EmpId];
       // NSLog(@"TimeSheet getbyEmpId query  %@",query);
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        while (sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            /*
             @property    double EmpId;
             @property    double ResourceAllocationID;
             @property    double ProjectId;
             @property    NSString *ProjectName;
             */
           TimeSheet *timeSheet=[[TimeSheet alloc]init];
            
            timeSheet.Id = (double)sqlite3_column_double(sqlStatement, 0);
            timeSheet.EmpId = (double)sqlite3_column_double(sqlStatement, 1);
            timeSheet.ResourceAllocationId = (double)sqlite3_column_double(sqlStatement, 2);
            timeSheet.ProjectId = (double)sqlite3_column_double(sqlStatement, 3);
            timeSheet.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
            timeSheet.ApprvedStatus = (double)sqlite3_column_double(sqlStatement, 5);
            timeSheet.SyncStatus = (double)sqlite3_column_double(sqlStatement, 6);
            
            timeSheet.EntryDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,7)]];
            timeSheet.ApprovalDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,8)]];
            
            timeSheet.Module  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,9)];
            
            timeSheet.WeekStartDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,10)]];
            timeSheet.WeekEndDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,11)]];
            
            NSMutableString *weekenddate =  [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,11)];
            
            timeSheet.Day1_WH = (double)sqlite3_column_double(sqlStatement, 12);
            timeSheet.Day2_WH = (double)sqlite3_column_double(sqlStatement, 13);
            timeSheet.Day3_WH = (double)sqlite3_column_double(sqlStatement, 14);
            timeSheet.Day4_WH = (double)sqlite3_column_double(sqlStatement, 15);
            timeSheet.Day5_WH = (double)sqlite3_column_double(sqlStatement, 16);
            timeSheet.Day6_WH = (double)sqlite3_column_double(sqlStatement, 17);
            timeSheet.Day7_WH = (double)sqlite3_column_double(sqlStatement, 18);
            
            timeSheet.Day1_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,19)];
            timeSheet.Day2_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,20)];
            timeSheet.Day3_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,21)];
            timeSheet.Day4_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,22)];
            timeSheet.Day5_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,23)];
            timeSheet.Day6_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,24)];
            timeSheet.Day7_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,25)];
            
            [arrTimeSheet addObject:timeSheet];
            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Employee : %@", [exception reason]);
    }
    @finally {
        return arrTimeSheet;
    }
}

- (NSMutableArray *) getTimeSheetWithEmployeeId:(double)EmpId andWithWeekEndDate:(NSDate *)WeekEndDate {
    
    NSMutableArray *arrTimeSheet = [[NSMutableArray alloc] init];
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    
    NSString *tableName=@"TimeSheetEntry";
    
    @try {
        
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        NSString *strDateInUTC=[dateFormatter stringFromDate:WeekEndDate];
        NSDate *FormatedWeekDate =[dateFormatter dateFromString:strDateInUTC];
        // NSLog(@"FormatedWeekDate    %@",FormatedWeekDate);
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE EmpId=%.0f AND WeekEndDate='%@'",tableName,EmpId,
                FormatedWeekDate];
        
        // NSLog(@"TimeSheet getbyEmpId query  %@",query);
        
        
        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        while (sqlite3_step(sqlStatement) == SQLITE_ROW)
        {
            
            TimeSheet *timeSheet=[[TimeSheet alloc]init];
            
            timeSheet.Id = (double)sqlite3_column_double(sqlStatement, 0);
            timeSheet.EmpId = (double)sqlite3_column_double(sqlStatement, 1);
            timeSheet.ResourceAllocationId = (double)sqlite3_column_double(sqlStatement, 2);
            timeSheet.ProjectId = (double)sqlite3_column_double(sqlStatement, 3);
            timeSheet.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];;
            timeSheet.ApprvedStatus = (double)sqlite3_column_double(sqlStatement, 5);
            timeSheet.SyncStatus = (double)sqlite3_column_double(sqlStatement, 6);
            
            timeSheet.EntryDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,7)]];
            timeSheet.ApprovalDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,8)]];
            
            timeSheet.Module  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,9)];
            
            timeSheet.WeekStartDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,10)]];
            timeSheet.WeekEndDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,11)]];
            
            NSMutableString *weekenddate =  [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,11)];
            
            timeSheet.Day1_WH = (double)sqlite3_column_double(sqlStatement, 12);
            timeSheet.Day2_WH = (double)sqlite3_column_double(sqlStatement, 13);
            timeSheet.Day3_WH = (double)sqlite3_column_double(sqlStatement, 14);
            timeSheet.Day4_WH = (double)sqlite3_column_double(sqlStatement, 15);
            timeSheet.Day5_WH = (double)sqlite3_column_double(sqlStatement, 16);
            timeSheet.Day6_WH = (double)sqlite3_column_double(sqlStatement, 17);
            timeSheet.Day7_WH = (double)sqlite3_column_double(sqlStatement, 18);
            
            timeSheet.Day1_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,19)];
            timeSheet.Day2_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,20)];
            timeSheet.Day3_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,21)];
            timeSheet.Day4_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,22)];
            timeSheet.Day5_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,23)];
            timeSheet.Day6_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,24)];
            timeSheet.Day7_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,25)];
            
            [arrTimeSheet addObject:timeSheet];
            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Employee : %@", [exception reason]);
    }
    @finally {
        return arrTimeSheet;
    }
}

- (NSMutableArray *) getTimeSheetWithEmployeeId:(double)EmpId withProjectID:(double)ProjectId andWithWeekEndDate:(NSDate *)WeekEndDate {
    
    NSMutableArray *arrTimeSheet = [[NSMutableArray alloc] init];
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;

    NSString *tableName=@"TimeSheetEntry";
    
    @try {
        
        
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        BOOL success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        
        NSString *strDateInUTC=[dateFormatter stringFromDate:WeekEndDate];
        NSDate *FormatedWeekDate =[dateFormatter dateFromString:strDateInUTC];
       // NSLog(@"FormatedWeekDate    %@",FormatedWeekDate);
        
        query= [NSString stringWithFormat:
                @"SELECT * FROM %@ WHERE EmpId=%.0f AND WeekEndDate='%@' AND ProjectId=%.0f",tableName,EmpId,
                FormatedWeekDate,ProjectId];
        
        // NSLog(@"TimeSheet getbyEmpId query  %@",query);
        

        dbResponse=sqlite3_prepare_v2(database, [query UTF8String], -1, &sqlStatement, NULL);
        
        while (sqlite3_step(sqlStatement) == SQLITE_ROW)
        {

            TimeSheet *timeSheet=[[TimeSheet alloc]init];
            
            timeSheet.Id = (double)sqlite3_column_double(sqlStatement, 0);
            timeSheet.EmpId = (double)sqlite3_column_double(sqlStatement, 1);
            timeSheet.ResourceAllocationId = (double)sqlite3_column_double(sqlStatement, 2);
            timeSheet.ProjectId = (double)sqlite3_column_double(sqlStatement, 3);
            timeSheet.ActivityId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,4)];
            timeSheet.ApprvedStatus = (double)sqlite3_column_double(sqlStatement, 5);
            timeSheet.SyncStatus = (double)sqlite3_column_double(sqlStatement, 6);
            
            timeSheet.EntryDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,7)]];
            timeSheet.ApprovalDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,8)]];
            
            timeSheet.Module  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,9)];
            
            timeSheet.WeekStartDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,10)]];
            
            timeSheet.WeekEndDate=[dateFormatter dateFromString: [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,11)]];
            
            NSMutableString *weekenddate =  [NSMutableString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,11)];
            
            timeSheet.Day1_WH = (double)sqlite3_column_double(sqlStatement, 12);
            timeSheet.Day2_WH = (double)sqlite3_column_double(sqlStatement, 13);
            timeSheet.Day3_WH = (double)sqlite3_column_double(sqlStatement, 14);
            timeSheet.Day4_WH = (double)sqlite3_column_double(sqlStatement, 15);
            timeSheet.Day5_WH = (double)sqlite3_column_double(sqlStatement, 16);
            timeSheet.Day6_WH = (double)sqlite3_column_double(sqlStatement, 17);
            timeSheet.Day7_WH = (double)sqlite3_column_double(sqlStatement, 18);
            
            timeSheet.Day1_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,19)];
            timeSheet.Day2_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,20)];
            timeSheet.Day3_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,21)];
            timeSheet.Day4_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,22)];
            timeSheet.Day5_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,23)];
            timeSheet.Day6_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,24)];
            timeSheet.Day7_Description  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,25)];
            
            [arrTimeSheet addObject:timeSheet];
            
        }
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(database);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Employee : %@", [exception reason]);
    }
    @finally {
        return arrTimeSheet;
    }
}

#pragma mark ClearDb Methods

//delete the employee from the database
-(BOOL)deleteFromtableName:(NSString *)tableName withEmplyeeId:(double)EmpId
{
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    BOOL success ;
   
    @try {
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        if (EmpId > 0) {
            
            query = [NSString stringWithFormat:@"DELETE from %@ WHERE EmpId = %f",tableName,EmpId];
            
            const char *delete_stmt = [query UTF8String];
            
            //            sqlite3_prepare(<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>);
            
            sqlite3_prepare_v2(database, delete_stmt, -1, &sqlStatement, NULL );
            sqlite3_bind_double(sqlStatement, 1, EmpId);
            
            if (sqlite3_step(sqlStatement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            NSLog(@"Not a valid Employee Id");
            success = true;
        }
        
        sqlite3_finalize(sqlStatement);
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured %@ : %@",tableName,[exception reason]);
    }
    @finally {
        sqlite3_close(database);
        return success;
    }
    

}



- (BOOL) deleteEmployeeWithEmployeeId:(double)EmpId
{
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    BOOL success ;
    NSString *tableName=@"Employee";
    @try {
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        if (EmpId > 0) {
            
            query = [NSString stringWithFormat:@"DELETE from %@ WHERE EmpId = %f",tableName,EmpId];
            
            const char *delete_stmt = [query UTF8String];
            
            //            sqlite3_prepare(<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>);
            
            sqlite3_prepare_v2(database, delete_stmt, -1, &sqlStatement, NULL );
            sqlite3_bind_double(sqlStatement, 1, EmpId);
            
            if (sqlite3_step(sqlStatement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            NSLog(@"Not a valid Employee Id");
            success = true;
            
        }
        
        sqlite3_finalize(sqlStatement);
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Employee : %@", [exception reason]);
    }
    @finally {
        sqlite3_close(database);
        return success;
    }
    
}

//delete the employee from the database
- (BOOL) deleteActivityWithEmployeeId:(double)EmpId
{
    
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    BOOL success ;
    NSString *tableName=@"Activity";
    
    @try {
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        if (EmpId > 0) {
            
            query = [NSString stringWithFormat:@"DELETE from %@ WHERE EmpId = %f",tableName,EmpId];
            
            const char *delete_stmt = [query UTF8String];
            
            sqlite3_prepare_v2(database, delete_stmt, -1, &sqlStatement, NULL );
            sqlite3_bind_double(sqlStatement, 1, EmpId);
            
            if (sqlite3_step(sqlStatement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            NSLog(@"Not a valid Employee Id");
            success = true;
            
        }
        
        sqlite3_finalize(sqlStatement);
        
}
@catch (NSException *exception) {
    NSLog(@"An exception occured Activity : %@", [exception reason]);
}
@finally {
    sqlite3_close(database);
    return success;
}

}



//delete the employee from the database
- (BOOL) deleteProjectWithEmployeeId:(double)EmpId
{
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    BOOL success;
    NSString *tableName=@"Project";
    
    @try {
    filemgr = [NSFileManager defaultManager];
    strDBPath = [self getDbPathForTableName:tableName];
    
   success = [filemgr fileExistsAtPath:strDBPath];
    
    if(!success)
    {
        NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
    }
    
    if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
    {
        NSLog(@"An error has occured.");
    }
    if (EmpId > 0) {
        /*
         @property    double EmpId;
         @property    double ResourceAllocationID;
         @property    double ProjectId;
         @property    NSString *ProjectName;
         */
        query = [NSString stringWithFormat:@"DELETE from %@ WHERE EmpIdocons = %f",tableName,EmpId];
        
        const char *delete_stmt = [query UTF8String];
        
        sqlite3_prepare_v2(database, delete_stmt, -1, &sqlStatement, NULL );
        sqlite3_bind_double(sqlStatement, 1, EmpId);
        
        if (sqlite3_step(sqlStatement) == SQLITE_DONE)
        {
            success = true;
        }
        
    }
    else{
        NSLog(@"Not a valid Employee Id for Project");
        success = true;
    }
    
    sqlite3_finalize(sqlStatement);
    
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured Employee : %@", [exception reason]);
    }
    @finally {
        return success;
        sqlite3_close(database);
    }
    
    return success;
}
- (BOOL) deleteTimesheetWithEmployeeId:(double)EmpId withProjectID:(double)ProjectId withActivityId:(NSString *)activityId andWithWeekEndDate:(NSDate *)weekendDate;
{
    NSString *query;
    sqlite3_stmt *sqlStatement=NULL;
    BOOL success;
    NSString *tableName=TABLE_TIME_SHEET_ENTRY;
    
    @try {
        filemgr = [NSFileManager defaultManager];
        strDBPath = [self getDbPathForTableName:tableName];
        
        success = [filemgr fileExistsAtPath:strDBPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate %@ database file '%@'.",tableName, strDBPath);
        }
        
        if(!(sqlite3_open([strDBPath UTF8String], &database) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        if (EmpId > 0) {
            /*
             @property    double EmpId;
             
             @property    double ProjectId;
             ActivityId
             //    @property NSDate *WeekEndDate;
             */
            query = [NSString stringWithFormat:@"DELETE from %@ WHERE EmpId = %.0f AND ProjectId = %.0f AND ActivityId ='%@' AND weekEndDate ='%@' ",tableName,EmpId,ProjectId,activityId,weekendDate];
            
            const char *delete_stmt = [query UTF8String];
            
            sqlite3_prepare_v2(database, delete_stmt, -1, &sqlStatement, NULL );
            sqlite3_bind_double(sqlStatement, 1, EmpId);
            
            if (sqlite3_step(sqlStatement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            NSLog(@"Not a valid Employee Id for TIMESHEET");
            success = true;
        }
        
        sqlite3_finalize(sqlStatement);
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured TIMESHEET : %@", [exception reason]);
    }
    @finally {
        return success;
        sqlite3_close(database);
    }
    
    return success;
}


#pragma mark DatabaseManager UnsortedMethods
-(NSString *) getDbPathForTableName:(NSString *)tableName
{
    NSString * docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];

//#if TARGET_IPHONE_SIMULATOR
//    // where are you?
//    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    //NSLog(@"docs Path %@",docsPath);
//#endif

    
    return [docsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"RMS_DATABASE.sqlite"]];
    
}
@end
