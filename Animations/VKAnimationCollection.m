//
//  VKAnimationCollection.m
//  CCAnimations
//
//  Created by Vsevolod Klementjev on 5/4/12.
//  Copyright (c) 2012 KleMiX. All rights reserved.
//

#import "VKAnimationCollection.h"
#import "VKStorage.h"
#import "VKSpriteFrameCache.h"
#import "VKImageFrame.h"

@implementation VKAnimationCollection

@synthesize collections = _collections;

-(NSDictionary*) collectionByName:(NSString*)name
{
    return [_collections objectForKey:name];
}

-(NSArray*) allAnimationCollections
{
    return [_collections allKeys];
}

-(NSMutableDictionary*) allAnimationsForCollection:(NSString*)collectionName
{
    NSDictionary *animationCollection = [_collections valueForKey:collectionName];
    
    if (animationCollection) {
       return [animationCollection valueForKey:@"animations"];
    }
    
    return nil;
}

-(NSMutableArray*) spriteSheetsForCollection:(NSString*)collectionName
{
    NSDictionary *animationCollection = [_collections valueForKey:collectionName];
    
    if (animationCollection) {
        NSDictionary *properties = [animationCollection valueForKey:@"properties"];
        
        if (properties) {
            return [properties valueForKey:@"spritesheets"];
        }
    }
    
    return nil;
}

-(UIImage*) previewImageForAniamtion:(NSString*)animationName inCollection:(NSString*)collection
{
    NSDictionary *animationCollection = (NSDictionary*)[_collections objectForKey:collection];
    
    if (animationCollection) {
        NSDictionary *animations = [animationCollection valueForKey:@"animations"];
        
        if (animations && [animations count] > 0)
        {
            NSDictionary *animation = [animations objectForKey:animationName];
            if (animation) {
                NSArray *frames = [animation objectForKey:@"frames"];
                if (frames && [frames count] > 0) {
                    NSDictionary *frame = [frames objectAtIndex:0];
                    NSString *frameName = [frame objectForKey:@"spriteframe"];
                    
                    if (frameName) {
                        return [[VKSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
                    }
                }
            }
        }
    }
    
    // In case something went wrong just return not found image
    return [UIImage imageNamed:@"ccanim-notfound.png"];
}

-(UIImage*) previewImageForCollection:(NSString*)animationCollectionName;
{
    NSDictionary *animationCollection = (NSDictionary*)[_collections objectForKey:animationCollectionName];
    
    if (animationCollection) {
        // getting first animation in collection
        NSDictionary *animations = [animationCollection valueForKey:@"animations"];
        
        if (animations && [animations count] > 0) {
            NSString *animationName = [[animations allKeys] objectAtIndex:0];
            if (animationName) {
                NSDictionary *animation = [animations objectForKey:animationName];
                NSArray *frames = [animation objectForKey:@"frames"];
                if (frames && [frames count] > 0) {
                    NSDictionary *frame = [frames objectAtIndex:0];
                    NSString *frameName = [frame objectForKey:@"spriteframe"];
                    
                    if (frameName) {
                        return [[VKSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
                    }
                }
            }
        }
    }
    
    // In case something went wrong just return not found image
    return [UIImage imageNamed:@"ccanim-notfound.png"];
}

-(void) saveCollection:(NSString*)collectionName
{
    NSDictionary *collection = [_collections valueForKey:collectionName];
    if (collection) {
//        [collection writeToFile:[[VKStorage sharedStorage] fullPathFromRelative:collectionName] atomically:YES];
    }
}

-(void) addFromFiles:(NSArray*)files
{
    // going through all files and if it's a plist, adding them one by one
    for (NSString *s in files) {
        if ([[s pathExtension] compare:@"plist"] == NSOrderedSame ) {
            [self addFromFile:s];
        }
    }
}

-(void) addFromFile:(NSString*)filePath
{
    // getting dictionary from it
    NSDictionary *collection = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    [self addWithDictionary:collection andFilename:filePath];
}

-(void) addWithDictionary:(NSDictionary*)collection andFilename:(NSString*)filePath
{
    if (collection) {
        // getting animations and adding them to our collections
        NSDictionary *animationCollection = [collection objectForKey:@"animations"];
        NSDictionary *propertiesCollection = [collection objectForKey:@"properties"];
        
        if (propertiesCollection && animationCollection) {
            NSNumber *format = [propertiesCollection objectForKey:@"format"];
            
            if ([format intValue] == 2) {
                NSArray *spritesheets = [propertiesCollection objectForKey:@"spritesheets"];
                
                for (NSString *spritesheet in spritesheets) {
                    // Loading frames to cache
                    [[VKSpriteFrameCache sharedSpriteFrameCache] addImageFramesWithFile:spritesheet];
                }
                
                [_collections setValue:collection forKey:[filePath lastPathComponent]];
            }
        }
    }
}

-(void) renameAnimation:(NSString*)oldName toName:(NSString*)newName inCollection:(NSString*)collection
{
    NSMutableDictionary *coll = [self allAnimationsForCollection:collection];
    NSDictionary *anim = [coll objectForKey:oldName];
    [coll removeObjectForKey:oldName];
    [coll setValue:anim forKey:newName];
}

-(void) wipeCollections
{
    [_collections removeAllObjects];
}

-(id) init
{
    if ((self = [super init])) {
        // just initializing our collections
        _collections = [NSMutableDictionary dictionaryWithCapacity:50];
    }
    
    return self;
}

// Singleton
+(VKAnimationCollection*) sharedCollection
{
    static VKAnimationCollection *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[VKAnimationCollection alloc] init];
    });
    return sharedInstance;
}

@end
