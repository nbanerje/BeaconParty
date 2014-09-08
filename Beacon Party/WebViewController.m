//
//  WebViewController.m
//  Beacon Party
//
//  Created by Neel Banerjee on 9/8/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _url = @"http://ziggy.is";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation



#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_loadingIndicator startAnimating];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_loadingIndicator stopAnimating];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog([error debugDescription]);
}

@end
