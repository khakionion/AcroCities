//
//  S3GamePoint.m
//  AcroCities
//
//  Created by Michael Herring on 1/26/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3GamePoint.h"

@implementation S3GamePoint

- (id)initWithGame:(PFObject *)game
{
    self = [super init];
    if (self) {
        [self setGame:game];
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    PFGeoPoint *point = [self.game valueForKey:@"centroid"];
    return CLLocationCoordinate2DMake(point.latitude, point.longitude);
}

- (NSString*)title {
    return [self.game valueForKey:@"lobbyName"];
}

- (NSString*)subtitle {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = kCFDateFormatterLongStyle;
    NSDate *theDate = (NSDate*)[self.game valueForKey:@"createdAt"];
    NSString *dateString = [df stringFromDate:theDate];
    NSString *createdPrefix = NSLocalizedString(@"Created on: ", @"Appears immediately before a calendar date");
    return [NSString stringWithFormat:@"%@%@", createdPrefix, dateString];
}

@end
