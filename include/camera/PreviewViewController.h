//
//  PreviewViewController.h
//  Hipster Christmas
//
//  Created by Tim Sears on 10/21/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "TouchCameraView.h"
#import "UIImage+Resize.h"
#import "Photo.h"
#import "PhotoRaw.h"
#import "PackScrollView.h"
#import "BorderScrollView.h"
#import "FilterScrollView.h"
#import "PackItemsViewController.h"
#import "PackItem.h"
#import "EnhanceWorker.h"
#import "ShareViewController.h"

#import "GAITrackedViewController.h"

@protocol PreviewViewControllerDelegate

@optional

-(void)didSaveImage:(UIImage *)image;

@end

typedef enum {kPreviewMode, kFilterMode, kBorderMode} PreviewViewState;

@interface PreviewViewController : GAITrackedViewController <PackScrollViewDelegate, PackItemsViewControllerDelegate, FilterScrollViewDelegate, BorderScrollViewDelegate, TouchCameraViewDelegate>
{
    NSManagedObjectContext  *managedObjectContext;
    PreviewViewState        viewState;
    
    UIImage *originalImage;
    UIImage *image; // this is the image we will be overlaying against
    
    IBOutlet UIImageView *bgView;
    IBOutlet UIImageView *borderView;
    
    PackScrollView      *packScrollView;
    FilterScrollView    *filterScrollView;
    BorderScrollView    *borderScrollView;
    
    IBOutlet UIButton    *btnDuplicate;
    IBOutlet UIButton    *btnRemove;
    IBOutlet UIButton    *btnSave;
    IBOutlet UILabel     *screenTitle;
    IBOutlet UILabel     *fxLabel;
    IBOutlet UIView      *touchArea;
    
    bool    isFrontCamera;
    bool    isFromCameraRoll;
    
    bool    isFilterMode;
    int     currentFilter;
    bool    isApplyingFilter;
}

-(void)prepareImage;

-(void)setBorder;

@property (strong) id<PreviewViewControllerDelegate>    delegate;

@property                     PreviewViewState  viewState;
@property (nonatomic, retain) UIImage   *image;
@property (nonatomic, retain) TouchCameraView   *touchCameraView;

@property bool  isFrontCamera;
@property bool  isFromCameraRoll;
@property int   borderNumber;

@end
