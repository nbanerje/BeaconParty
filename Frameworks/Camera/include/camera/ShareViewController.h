//
//  ShareViewController.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/18/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "UIImage+Resize.h"
#import "JSON.h"
#import "GAI.h"

#import "GAITrackedViewController.h"

@interface ShareViewController : GAITrackedViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    UIImage *image;
    SLComposeViewController *facebook;
    SLComposeViewController *twitter;
    UIDocumentInteractionController *instagram;
    
    UIActivityIndicatorView *activityIndicator;
    
    UIButton *btnFacebook;
    
    NSString *fbPhotoId;
    
    IBOutlet UIImageView* bgView;
    IBOutlet UILabel* screenTitle;
}

@property (strong) UIImage *image;

@end
