//
//  VKAnimationCollection.h
//  CCAnimations
//
//  Created by Vsevolod Klementjev on 5/4/12.
//  Copyright (c) 2012 KleMiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAnimationCollection : NSObject {
    NSMutableDictionary *_collections;
}

-(void) wipeCollections;

-(void) addFromFiles:(NSArray*)files;
-(void) addFromFile:(NSString*)filePath;
-(void) addWithDictionary:(NSDictionary*)contents andFilename:(NSString*)filename;

-(void) saveCollection:(NSString*)collectionName;

-(NSMutableDictionary*) collectionByName:(NSString*)name;
-(NSArray*) allAnimationCollections;
-(NSMutableDictionary*) allAnimationsForCollection:(NSString*)collectionName;

-(void) renameAnimation:(NSString*)oldName toName:(NSString*)newName inCollection:(NSString*)collection;

-(UIImage*) previewImageForCollection:(NSString*)animationName;
-(UIImage*) previewImageForAniamtion:(NSString*)animationName inCollection:(NSString*)collection;

-(NSMutableArray*) spriteSheetsForCollection:(NSString*)collectionName;

@property (nonatomic, strong) NSMutableDictionary *collections;

// singleton
+(VKAnimationCollection*) sharedCollection;

@end
