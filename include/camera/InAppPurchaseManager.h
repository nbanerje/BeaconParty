//
//  InAppPurchaseManager.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/22/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification        @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification      @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification   @"kInAppPurchaseManagerTransactionSucceededNotification"
#define kInAppPurchaseManagerRefreshedNotification              @"kInAppPurchaseManagerRefreshedNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    
}

+ (InAppPurchaseManager *)sharedPurchaseManager;

-(void)requestProductDescriptions;
-(void)purchaseProduct:(NSString *)productId;

@property (strong) NSMutableDictionary  *products;
@property (strong) SKProductsRequest   *productsRequest;

@end
