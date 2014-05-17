//
//  VKStorage.h
//  CCAnimations
//
//  Created by Vsevolod Klementjev on 5/4/12.
//  Copyright (c) 2012 KleMiX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKStorage : NSObject

// Singleton
+(VKStorage *) sharedStorage;

-(NSArray*) listOfFiles;
//-(NSString*) fullPathFromRelative:(NSString*)relativePath;

-(NSData*) dataFromFile:(NSString*)filename;
-(NSMutableDictionary*) dictionaryFromFile:(NSString*)filename;

@property (nonatomic) BOOL shouldDownloadTouchedFiles;

@end
