//
//  OMDMediaDB.h
//  WeddingSnap
//
//  Created by Neel Banerjee on 12/1/12.
//  Copyright (c) 2012 Om Design LLC. All rights reserved.
//

#import "OMDSQLLite.h"
#import "OMDMediaObject.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import <ImageIO/ImageIO.h>
#import "OmDesignCredential.h"

enum {
    OMDMediaDBWaitingForUploadStatus = 0,
    OMDMediaDBUploadedStatus = 1,
    OMDMediaDBPartialUploadStatus = 2,
    OMDMediaDBFileDNELocallyStatus = 3,
    OMDMediaDBFileDNERemotelyStatus = 4,
    OMDMediaDBFileIsCorruptStatus = 5
};

@interface OMDMediaDB : OMDSQLLite

@property (atomic,strong) NSMutableDictionary *mediaObjects;
@property (atomic) NSInteger totalNumPics;
@property (atomic) NSInteger waitingNumPics;
@property (atomic) NSInteger uploadedNumPics;
@property (nonatomic) BOOL uploadPaused;
@property (nonatomic, strong) NSOperationQueue* queue;
@property (nonatomic, strong) NSTimer *restartUploadTimer;
@property (nonatomic) uint32_t totalQueued;
@property (nonatomic) BOOL notTakingPics;
@property (nonatomic,strong) OmDesignCredential *cred;
@property (nonatomic,strong) NSString *key;

+ (id)sharedInstance;
-(dispatch_queue_t) getBackgroundQueue;
-(id) init;

-(void)startUploading:(NSString*)baseURL path:(NSString*)path;
-(void)setEntryStatus:(int)ID status:(int)status;

-(void)makeTnWithMediaObject:(OMDMediaObject*)obj orWithUIImage:(UIImage*)image withFilename:(NSString*) imageFilename;
-(void)makeTnWithMediaObject:(OMDMediaObject*)obj orWithUIImageData:(NSData*)image withFilename:(NSString*) imageFilename;

-(void)addImage:(UIImage*)imageData unpause:(BOOL) unpause;
-(void)addImageData:(NSData*)imageData unpause:(BOOL) unpause;
-(void)updateNums;

-(NSInteger) getTotalNumPics;
-(NSInteger) getWaitingNumPics;
-(NSInteger) getUploadNumPics;

-(uint64_t)getFreeDiskspace;

-(NSString*)getDocPath:(NSURL*) url;
-(BOOL) validFile:(NSURL*) url;

-(void)dumpTumbs;
-(NSArray*) sortedKeys;
-(void) killUploadsAndPause;


@end
