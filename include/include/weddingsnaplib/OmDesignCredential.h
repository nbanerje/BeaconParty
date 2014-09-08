//
//  OmDesignCredential.h
//  WeddingSnap
//
//  Created by Neel Banerjee on 5/1/11.
//  Copyright 2011 Om Design LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface OmDesignCredential : NSObject {
}

@property (readonly, nonatomic) BOOL keyPassed;
@property (nonatomic, strong) NSString *key;
-(void) checkKey:(NSString*)key url:(NSString*)url path:(NSString*)path;
-(void) keyFailed;
@end
