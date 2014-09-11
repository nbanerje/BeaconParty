//
//  PackWorker.h
//  Hipster Christmas
//
//  Created by Tim Sears on 10/28/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSON.h"
#import "Pack.h"
#import "PackItem.h"
#import "AppDelegate.h"

@interface PackWorker : NSObject
{
    
}

+(NSArray *)generateBasePacks;

+(NSArray *)loadPacks:(bool)includePaid;

@end
