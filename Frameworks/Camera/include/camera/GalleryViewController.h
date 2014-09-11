//
//  GalleryViewController.h
//  Hipster Christmas
//
//  Created by Tim Sears on 10/21/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "TouchCameraView.h"
#import "UIImage+Resize.h"
#import "PreviewViewController.h"
#import "PackItemsViewController.h"
#import "ShareViewController.h"
#import "PhotoWorker.h"
#import "Photo.h"
#import "PhotoPaginator.h"
#import "InAppPurchaseManager.h"

#import "GAITrackedViewController.h"


@interface GalleryViewController : GAITrackedViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, TouchCameraViewDelegate, PackScrollViewDelegate,PackItemsViewControllerDelegate,
                                                    PreviewViewControllerDelegate, PhotoPaginatorDelegate, UIAlertViewDelegate>
{
    NSManagedObjectContext     *managedObjectContext;
    UIImagePickerController    *picker;
    TouchCameraView            *overlay;
    PhotoPaginator             *paginator;
    
    NSArray                    *photos;
    
    bool                       isCameraFront;
    bool                       isImageFromLibrary;
    
    UIButton                   *btnDuplicate;
    UIButton                   *btnRemove;
    UILabel                    *title;
    

}

@property (weak,nonatomic) IBOutlet UIButton *btnNewpic;

-(void)popReviewPrompt;

@end
