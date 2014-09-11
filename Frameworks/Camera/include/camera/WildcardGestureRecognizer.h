//
//  WildcardGestureRecognizer.h
//  Copyright 2010 Floatopian LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^TouchesEventBlock)(NSSet * touches, UIEvent * event);

@interface WildcardGestureRecognizer : UIGestureRecognizer {
    
    bool touchesMoved;
    TouchesEventBlock touchesBeganCallback;
    TouchesEventBlock touchesMovedCallback;
    TouchesEventBlock touchesEndedCallback;
}

@property(copy) TouchesEventBlock touchesBeganCallback;
@property(copy) TouchesEventBlock touchesMovedCallback;
@property(copy) TouchesEventBlock touchesEndedCallback;


@end
