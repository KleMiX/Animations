//
//  VKImageFrame.m
//  Animations
//
//  Created by KleMiX on 8/20/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import "VKImageFrame.h"

@implementation VKImageFrame

+(id) frameWithImage:(UIImage*)sourceImage rotated:(BOOL)rotated  andRect:(CGRect)rect
{
    return [[VKImageFrame alloc] initWithImage:sourceImage rotated:rotated andRect:rect];
}

-(id) initWithImage:(UIImage*)sourceImage rotated:(BOOL)rotated andRect:(CGRect)rect
{
    if ((self =[super init]))
    {
        // crop our frame out of source image
        CGImageRef imageRef = CGImageCreateWithImageInRect([sourceImage CGImage], rect);
        self.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        if (rotated) // rotate the image in case 
        {
            self.image = [UIImage imageWithCGImage:self.image.CGImage scale:self.image.scale orientation:UIImageOrientationLeft];
        }

    }
    
    return self;
}

@end
