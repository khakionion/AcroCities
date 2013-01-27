//
//  S3GameSearching.h
//  AcroCities
//
//  Created by Michael Herring on 1/26/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    kS3GameSearchTypeLocationBased = 0,
    kS3GameSearchTypeUserIDBased,
    kS3GameSearchTypeGlobalGames,
} kS3GameSearchType;

@protocol S3GameResultHandler <NSObject>

- (void)foundGames:(NSArray*)gameArray fromSearchType:(kS3GameSearchType)searchType;

@end

@interface S3GameSearching : NSObject

+ (void)gamesNearLatitude:(double)lat longitude:(double)lon withinRange:(double)range notifyTarget:(NSObject<S3GameResultHandler>*)target;

@end
