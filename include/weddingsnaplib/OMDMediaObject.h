//
//  OMDMediaObject.h
//  WeddingSnap
//
//  Created by Neel Banerjee on 12/1/12.
//  Copyright (c) 2012 Om Design LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "OMDMediaDB.h"

enum {
        OMDMediaTypePhoto = 1,
        OMDMediaTypeMovie
};


@interface OMDMediaObject : NSObject {

}

@property (nonatomic) NSInteger ID;
@property (nonatomic,strong) UIImage* thumbnail;
@property (nonatomic,strong) NSURL* location;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger time;
@property (nonatomic) long long uploadedBytes;
@property (nonatomic) long long totalBytes;

@end
