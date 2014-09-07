//
//  OMDSQLLite.h
//  WeddingSnap
//
//  Created by Neel Banerjee on 12/1/12.
//  Copyright (c) 2012 Om Design LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface OMDSQLLite : NSObject {
    sqlite3 *database;
    
    dispatch_queue_t backgroundQueue;
}

@property (nonatomic, weak) NSString *dbFilename;

+ (id)sharedInstance;
- (void) initWithFilename:(NSString*) dbfilename;
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;

@end
