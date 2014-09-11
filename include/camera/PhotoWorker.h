//
//  PhotoWorker.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/11/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoWorker : NSObject


+(NSArray *)fetchAllPhotos:(NSManagedObjectContext *)managedObjectContext;

@end
