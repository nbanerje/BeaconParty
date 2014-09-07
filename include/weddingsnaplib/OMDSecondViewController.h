//
//  OMDSecondViewController.h
//  WeddingSnap
//
//  Created by Neel Banerjee on 11/25/12.
//  Copyright (c) 2012 Om Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OmDesignCredential.h"
#import "GAITrackedViewController.h"

@interface OMDSecondViewController : GAITrackedViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet NSMutableString *key;
@property (nonatomic,strong) IBOutlet UITextField *keyUITextField;
@property (strong, nonatomic) OmDesignCredential* cred;
-(IBAction) infoPressed:(id) sender ;
@end
