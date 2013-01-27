//
//  S3GameSearching.m
//  AcroCities
//
//  Created by Michael Herring on 1/26/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3GameSearching.h"
#import <Parse/Parse.h>

#define kS3DegreesToKilometers 111

@implementation S3GameSearching

+ (void)gamesNearLatitude:(double)lat longitude:(double)lon withinRange:(double)range notifyTarget:(NSObject<S3GameResultHandler>*)target {
    PFQuery *gameQuery = [PFQuery queryWithClassName:@"Game"];
    PFGeoPoint *convertedPoint = [PFGeoPoint geoPointWithLatitude:lat longitude:lon];
    [gameQuery whereKey:@"centroid" nearGeoPoint:convertedPoint withinKilometers:range];
    __block NSArray * answer = nil;
    [gameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *findError) {
        if (findError == nil) {
            answer = [objects copy];
            if ([target respondsToSelector:@selector(foundGames:fromSearchType:)]) {
                [target foundGames:answer fromSearchType:kS3GameSearchTypeLocationBased];
            }
        }
    }];
}

@end
