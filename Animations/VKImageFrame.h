//
//  VKImageFrame.h
//  Animations
//
//  Created by KleMiX on 8/20/13.
//  Copyright (c) 2013 Vsevolod Klemetjev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKImageFrame : NSObject

+(id) frameWithImage:(UIImage*)sourceImage rotated:(BOOL)rotated  andRect:(CGRect)rect;
-(id) initWithImage:(UIImage*)sourceImage rotated:(BOOL)rotated  andRect:(CGRect)rect;

@property (nonatomic, strong) UIImage *image;

@end
