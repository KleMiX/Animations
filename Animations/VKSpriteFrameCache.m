//
//  VKSpriteFrameCache.m
//  CCAnimations
//
//  Created by Vsevolod Klementjev on 5/4/12.
//  Copyright (c) 2012 KleMiX. All rights reserved.
//

#import "VKSpriteFrameCache.h"
#import "VKStorage.h"
#import "VKImageFrame.h"

@implementation VKSpriteFrameCache

-(id) init
{
    if ((self = [super init])) {
        _frames = [NSMutableDictionary dictionaryWithCapacity:50];
        _aliases = [NSMutableDictionary dictionaryWithCapacity:10];
        
        // load frame to show if something will not be found
//        UIImage *texNotFound = [UIImage imageNamed:@"ccanim-notfound.png"]; //[[CCTextureCache sharedTextureCache] addImage:@"ccanim-notfound.png"];
//        CGRect rect = CGRectMake(0, 0, texNotFound.contentSize.width, texNotFound.contentSize.height);
        _notFoundFrame = [UIImage imageNamed:@"ccanim-notfound.png"];
        _plistFiles = [NSMutableArray arrayWithCapacity:10];
    }
        
    return self;
}

-(NSArray*) allSpriteFrameNames
{
    NSArray *frames = [_frames allKeys];
    NSArray *aliases = [_aliases allKeys];
    
    int count = [frames count] + [aliases count];
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:count];
    
    for (NSString* s in frames) {
        [names addObject:s];
    }
    for (NSString* s in aliases) {
        [names addObject:s];
    }
    
    return names;
}

-(NSArray*) allPlistFiles
{
    return _plistFiles;
}

-(void) wipeCache
{
    [_frames removeAllObjects];
    [_aliases removeAllObjects];
    [_plistFiles removeAllObjects];
}

#pragma mark VKSpriteFrameCache - getting

-(UIImage*) spriteFrameByName:(NSString*)name
{
	VKImageFrame *frame = [_frames objectForKey:name];
	if( ! frame ) {
		// try alias dictionary
		NSString *key = [_aliases objectForKey:name];
		frame = [_frames objectForKey:key];
		
        // jsut show our supa pupa frame
		if( ! frame )
			return _notFoundFrame;
	}
	
	return frame.image;
}

#pragma mark VKSpriteFrameCache - loading sprite frames

-(void) addImageFramesWithDictionary:(NSDictionary*)dictionary image:(UIImage*)image
{
	/*
	 Supported Zwoptex Formats:
	 ZWTCoordinatesFormatOptionXMLLegacy = 0, // Flash Version
	 ZWTCoordinatesFormatOptionXML1_0 = 1, // Desktop Version 0.0 - 0.4b
	 ZWTCoordinatesFormatOptionXML1_1 = 2, // Desktop Version 1.0.0 - 1.0.1
	 ZWTCoordinatesFormatOptionXML1_2 = 3, // Desktop Version 1.0.2+
     */
	NSDictionary *metadataDict = [dictionary objectForKey:@"metadata"];
	NSDictionary *framesDict = [dictionary objectForKey:@"frames"];
    
	int format = 0;
	
	// get the format
	if(metadataDict != nil)
		format = [[metadataDict objectForKey:@"format"] intValue];
	
	// check the format
	NSAssert( format >= 0 && format <= 3, @"cocos2d: WARNING: format is not supported for CCSpriteFrameCache addSpriteFramesWithDictionary:texture:");
	
	
	// add real frames
	for(NSString *frameDictKey in framesDict) {
		NSDictionary *frameDict = [framesDict objectForKey:frameDictKey];
		VKImageFrame *imageFrame=nil;
		if(format == 0) {
			float x = [[frameDict objectForKey:@"x"] floatValue];
			float y = [[frameDict objectForKey:@"y"] floatValue];
			float w = [[frameDict objectForKey:@"width"] floatValue];
			float h = [[frameDict objectForKey:@"height"] floatValue];
			float ox = [[frameDict objectForKey:@"offsetX"] floatValue];
			float oy = [[frameDict objectForKey:@"offsetY"] floatValue];
			int ow = [[frameDict objectForKey:@"originalWidth"] intValue];
			int oh = [[frameDict objectForKey:@"originalHeight"] intValue];
			// check ow/oh
			if(!ow || !oh)
				NSLog(@"cocos2d: WARNING: originalWidth/Height not found on the CCSpriteFrame. AnchorPoint won't work as expected. Regenerate the .plist");
			
			// abs ow/oh
			ow = abs(ow);
			oh = abs(oh);
			// create frame
			
            imageFrame = [VKImageFrame frameWithImage:image rotated:NO andRect:CGRectMake(x+ox, y+oy, w, h)];
//			spriteFrame = [[CCSpriteFrame alloc] initWithTexture:texture
//													rectInPixels:CGRectMake(x, y, w, h)
//														 rotated:NO
//														  offset:CGPointMake(ox, oy)
//													originalSize:CGSizeMake(ow, oh)];
		} else if(format == 1 || format == 2) {
			CGRect frame = CGRectFromString([frameDict objectForKey:@"frame"]);
			BOOL rotated = NO;
			
			// rotation
			if(format == 2)
				rotated = [[frameDict objectForKey:@"rotated"] boolValue];
			
//			CGPoint offset = CGPointFromString([frameDict objectForKey:@"offset"]);
//			CGSize sourceSize = CGSizeFromString([frameDict objectForKey:@"sourceSize"]);
			
			// create frame
            imageFrame = [VKImageFrame frameWithImage:image rotated:rotated andRect:frame];
//			spriteFrame = [[CCSpriteFrame alloc] initWithTexture:texture
//													rectInPixels:frame
//														 rotated:rotated
//														  offset:offset
//													originalSize:sourceSize];
		} else if(format == 3) {
			// get values
			CGSize spriteSize = CGSizeFromString([frameDict objectForKey:@"spriteSize"]);
			CGPoint spriteOffset = CGPointFromString([frameDict objectForKey:@"spriteOffset"]);
//			CGSize spriteSourceSize = CGSizeFromString([frameDict objectForKey:@"spriteSourceSize"]);
			CGRect textureRect = CGRectFromString([frameDict objectForKey:@"textureRect"]);
			BOOL textureRotated = [[frameDict objectForKey:@"textureRotated"] boolValue];
			
			// get aliases
			NSArray *aliases = [frameDict objectForKey:@"aliases"];
			for(NSString *alias in aliases) {
				if( [_aliases objectForKey:alias] )
					NSLog(@"cocos2d: WARNING: an alias with name %@ already exists",alias);
				
				[_aliases setObject:frameDictKey forKey:alias];
			}
			
			// create frame
            imageFrame = [VKImageFrame frameWithImage:image rotated:textureRotated andRect:CGRectMake(textureRect.origin.x+spriteOffset.x, textureRect.origin.y+spriteOffset.y, spriteSize.width, spriteSize.height)];
//			spriteFrame = [[CCSpriteFrame alloc] initWithTexture:texture 
//													rectInPixels:CGRectMake(textureRect.origin.x, textureRect.origin.y, spriteSize.width, spriteSize.height) 
//														 rotated:textureRotated 
//														  offset:spriteOffset 
//													originalSize:spriteSourceSize];
		}
        
		// add sprite frame
		[_frames setObject:imageFrame forKey:frameDictKey];
	}
}

//-(void) addSpriteFramesWithFile:(NSString*)plist texture:(CCTexture2D*)texture
//{
//	NSString *path = [[VKStorage sharedStorage] fullPathFromRelative:plist];
//	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
//    
//	[self addSpriteFramesWithDictionary:dict texture:texture];
//}
//
//-(void) addSpriteFramesWithFile:(NSString*)plist textureFile:(NSString*)textureFileName
//{
//	NSAssert( textureFileName, @"Invalid texture file name");
//	CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:textureFileName];
//	
//	if( texture )
//		[self addSpriteFramesWithFile:plist texture:texture];
//	else
//		CCLOG(@"cocos2d: CCSpriteFrameCache: couldn't load texture file. File not found: %@", textureFileName);
//}
//
-(void) addImageFramesWithFile:(NSString*)plist
{
    // check for duplicate file
    for (NSString *file in _plistFiles) {
        if ([file compare:plist] == NSOrderedSame) {
            // don't bother, we already have it
            return;
        }
    }
    
    NSString *path = plist;
    NSDictionary *dict = [[VKStorage sharedStorage] dictionaryFromFile:plist];
	
    NSString *texturePath = nil;
    NSDictionary *metadataDict = [dict objectForKey:@"metadata"];
    if( metadataDict )
        // try to read  texture file name from meta data
        texturePath = [metadataDict objectForKey:@"textureFileName"];
	
	
    if( texturePath )
    {
        // build texture path relative to plist file
        NSString *textureBase = [path stringByDeletingLastPathComponent];
        texturePath = [textureBase stringByAppendingPathComponent:texturePath];
    } else {
        // build texture path by replacing file extension
        texturePath = [path stringByDeletingPathExtension];
        texturePath = [texturePath stringByAppendingPathExtension:@"png"];
		
		NSLog(@"CCAnimator: VKSpriteFrameCache: Trying to use file '%@' as texture", texturePath); 
    }
	
//    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:texturePath];
	UIImage *image = [UIImage imageWithData:[[VKStorage sharedStorage] dataFromFile:texturePath]];
    
	if( image )
		[self addImageFramesWithDictionary:dict image:image];
	
	else
		NSLog(@"CCAnimator: VKSpriteFrameCache: Couldn't load texture");
    
    if (image && dict)
        [_plistFiles addObject:plist];
}
//
//-(void) addSpriteFrame:(CCSpriteFrame*)frame name:(NSString*)frameName
//{
//	[_frames setObject:frame forKey:frameName];
//}

// Singleton
+(VKSpriteFrameCache*) sharedSpriteFrameCache
{
    static VKSpriteFrameCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[VKSpriteFrameCache alloc] init];
    });
    return sharedInstance;
}

@end
