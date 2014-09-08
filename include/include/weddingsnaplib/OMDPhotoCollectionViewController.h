//
//  OMDPhotoCollectionViewController.h
//  WeddingSnap
//
//  Created by Neel Banerjee on 12/8/12.
//  Copyright (c) 2012 Om Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMDMediaDB.h"

@interface OMDPhotoCollectionViewController : UICollectionViewController <UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    dispatch_queue_t _iconQueue;
}

@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) OMDMediaDB* mediaDB;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UILabel *footerLabel;

//@property (nonatomic, strong) NSMutableArray* pictureArray;
//@property (nonatomic, strong) NSMutableArray* cacheArray;
@property (nonatomic,strong)  NSCache* picCache;
-(void) updateIcons:(NSNotification *)notification;
-(void) loadImagesForOnscreenRows;
-(void) loadImagesForIndexPath:(NSIndexPath*) indexPath;
-(IBAction)returned:(UIStoryboardSegue *)segue;
@end
