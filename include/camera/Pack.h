//
//  Pack.h
//  Hipster Christmas
//
//  Created by Tim Sears on 10/28/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pack : NSObject
{
    NSString                                        *name;
    NSString                                        *productId;
    bool                                            isPaid;
    bool                                            hasPurchased;
    bool                                            isActive;
    NSString                                        *price;
    NSString                                        *image;
    
    NSArray                                         *items;
    
}


@property (strong) NSString                         *name;
@property (strong) NSString                         *productId;
@property bool                                      isPaid;
@property bool                                      hasPurchased;
@property bool                                      isActive;
@property (strong) NSString                         *price;
@property (strong) NSString                         *image;

@property (strong) NSArray                          *items;

@end
