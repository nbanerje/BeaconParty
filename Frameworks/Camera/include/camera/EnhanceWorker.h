//
//  EnhanceWorker.h
//  Hipster Christmas
//
//  Created by Tim Sears on 11/20/11.
//  Copyright (c) 2011 ISITE Design Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ImageFilter.h"

@interface EnhanceWorker : NSObject


+(UIImage *)filterNormal:(UIImage *)originalImage;

+(UIImage *)saturatedFilter:(UIImage *)originalImage;

+(UIImage *)filterTwo:(UIImage *)originalImage;

+(UIImage *)blackandwhiteFilter:(UIImage *)originalImage;

+(UIImage *)sepiaFilter:(UIImage *)originalImage;

+(UIImage *)sixtiesFilter:(UIImage *)originalImage;

+(UIImage *)xmoFilter:(UIImage *)originalImage;

+(UIImage *)comicFilter:(UIImage *)originalImage;

+(UIImage *)sunnyFilter:(UIImage *)originalImage;

+(UIImage *)polaroid:(UIImage *)originalImage;

+(UIImage *)lomo:(UIImage *)originalImage;

+(UIImage *)vignette:(UIImage *)originalImage;

+(UIImage *)vignetteDark:(UIImage *)originalImage;

@end
