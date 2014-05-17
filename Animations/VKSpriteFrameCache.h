//
//  VKSpriteFrameCache.h
//  CCAnimations
//
//  Created by Vsevolod Klementjev on 5/4/12.
//  Copyright (c) 2012 KleMiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKSpriteFrameCache : NSObject {
    NSMutableDictionary *_frames;
    NSMutableDictionary *_aliases;
    UIImage *_notFoundFrame;
    NSMutableArray *_plistFiles;
}

+(VKSpriteFrameCache*) sharedSpriteFrameCache;

-(NSArray*) allPlistFiles;
-(NSArray*) allSpriteFrameNames;
-(UIImage*) spriteFrameByName:(NSString*)name;

-(void) wipeCache;

-(void) addImageFramesWithDictionary:(NSDictionary*)dictionary image:(UIImage*)image;
//-(void) addSpriteFramesWithFile:(NSString*)plist texture:(CCTexture2D*)texture;
//-(void) addSpriteFramesWithFile:(NSString*)plist textureFile:(NSString*)textureFileName;
-(void) addImageFramesWithFile:(NSString*)plist;
//-(void) addSpriteFrame:(CCSpriteFrame*)frame name:(NSString*)frameName;

@end
