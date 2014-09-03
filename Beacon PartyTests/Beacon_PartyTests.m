//
//  Beacon_PartyTests.m
//  Beacon PartyTests
//
//  Created by Neel Banerjee on 8/23/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OMDScreenColorSpec.h"

@interface Beacon_PartyTests : XCTestCase

@property (strong, nonatomic) OMDScreenColorSpec *colorSpec;

@end

@implementation Beacon_PartyTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testScreenColorSpec {
    _colorSpec = [[OMDScreenColorSpec alloc] initWithColor1:[UIColor orangeColor] color2:[UIColor purpleColor]];
    //_colorSpec.view = self.view;
    _colorSpec.frequency = 2;
    [_colorSpec block]();
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(stop)
                                   userInfo:nil
                                    repeats:NO];
    
}

- (void)stop {
    [_colorSpec stopBlock]();
}


@end
