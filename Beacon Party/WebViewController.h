//
//  WebViewController.h
//  Beacon Party
//
//  Created by Neel Banerjee on 9/8/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *url;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end
