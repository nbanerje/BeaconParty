//
//  PhotoRaw.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/13/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface PhotoRaw : NSManagedObject

@property (nonatomic, retain) NSData * photodata;
@property (nonatomic, retain) Photo *photo;

@end
