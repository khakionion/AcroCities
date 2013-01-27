//
//  S3GamePoint.h
//  AcroCities
//
//  Created by Michael Herring on 1/26/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface S3GamePoint : NSObject <MKAnnotation>

@property (readwrite, strong) PFObject *game;
@property (readwrite, strong) MKAnnotationView *annotationView;

- (id)initWithGame:(PFObject*)game;

@end
