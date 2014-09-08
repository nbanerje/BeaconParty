//
//  AboutEventViewController.m
//  Beacon Party
//
//  Created by Neel Banerjee on 9/8/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "AboutEventViewController.h"
#import "WebViewController.h"
@interface AboutEventViewController ()

@end

@implementation AboutEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebViewController *wvc = segue.destinationViewController;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([((UIButton*)sender).currentTitle compare:@"Buy Now"] ) {
        wvc.url = @"http://ziggypdx.eventbrite.com/";
    } else if ([((UIButton*)sender).currentTitle compare:@"Sponsor"] ) {
        wvc.url = @"http://igg.me/at/zig/";
    } else {
        wvc.url = @"http://ziggy.is";
    }
    
    
}


@end
