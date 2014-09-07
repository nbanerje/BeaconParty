//
//  OMDFirstViewController.h
//  WeddingSnap
//
//  Created by Neel Banerjee on 11/25/12.
//  Copyright (c) 2012 Om Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "OMDMediaDB.h"
#import "OmDesignCredential.h"
#import <iAd/iAd.h>
#import "GAITrackedViewController.h"


@interface OMDFirstViewController : GAITrackedViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,ADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *holderView;

@property (weak, nonatomic) IBOutlet UIImageView *overlayImageView;

@property (strong, nonatomic) OmDesignCredential* cred;
@property (strong, nonatomic) NSMutableString *key;
@property (strong,nonatomic) Reachability* reach;
@property (readwrite, nonatomic) BOOL enableAd;

@property (weak, nonatomic) IBOutlet UIImageView  *stillImage;
@property (weak, nonatomic) IBOutlet UIImageView  *capturedImage;
@property (weak, nonatomic) IBOutlet UILabel *noCameraLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *manualUpload;

@property (weak, nonatomic) IBOutlet ADBannerView *ad;
@property (weak, nonatomic) IBOutlet UISegmentedControl *flashControl;
@property (weak, nonatomic) IBOutlet UIButton *keyButton;
@property (weak, nonatomic) IBOutlet UIButton *changeCamera;
@property (weak, nonatomic) IBOutlet UIView *topButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarTopSpace;

- (IBAction)toggleCamPreview:(id)sender;

-(IBAction) manualUploadPressed:(id) sender;
-(IBAction)picCollectionGesture:(UITapGestureRecognizer *)recognizer;
-(IBAction)flashSelected:(id)sender;
@end
