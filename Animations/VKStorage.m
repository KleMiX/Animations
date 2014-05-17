//
//  VKStorage.m
//  CCAnimations
//
//  Created by Vsevolod Klementjev on 5/4/12.
//  Copyright (c) 2012 KleMiX. All rights reserved.
//

#import "VKStorage.h"
#import <Dropbox/Dropbox.h>

@implementation VKStorage

//-(NSString*) fullPathFromRelative:(NSString*)relativePath
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    return [documentsDirectory stringByAppendingPathComponent:relativePath];
//}

-(NSArray*) listOfFiles
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
    if (documentsDirectory) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        return [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    }
    
    return nil;
}

-(NSData*) dataFromFile:(NSString*)filename
{
    if (self.shouldDownloadTouchedFiles)
    {
        NSString *filepath = [filename lastPathComponent];
        
        DBPath *dbpath = [[DBPath root] childPath:filepath];
        DBFile *file = [[DBFilesystem sharedFilesystem] openFile:dbpath error:nil];
        if (file)
        {
            // read the data - will ensure that file is downloaded
            return [file readData:nil];
        }
    }
    
    return nil;
}

-(NSMutableDictionary*) dictionaryFromFile:(NSString*)filename
{
    NSData *contents = [self dataFromFile:filename];
    if (contents)
    {
        NSString *error;
        NSPropertyListFormat format;
        // get the dictionary
        NSMutableDictionary* plist = [NSPropertyListSerialization propertyListFromData:contents mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
        return plist;
    }
    
    return nil;
}

// Singleton
+(VKStorage *) sharedStorage
{
    static VKStorage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[VKStorage alloc] init];
        sharedInstance.shouldDownloadTouchedFiles = NO;
    });
    return sharedInstance;
}

@end
