//
//  Smartlook+Segment.m
//  Smartlook
//
//  Created by Pavel Kroh on 26/05/2020.
//  Copyright © 2020 Smartsupp.com, s.r.o. All rights reserved.
//

#import "Segment-Smartlook.h"

// MARK: - Segment Integration Object
@interface SLSegmentIntegration : NSObject<SEGIntegration>

- (void)track:(SEGTrackPayload *)payload;

@end

@implementation SLSegmentIntegration

- (void)track:(SEGTrackPayload *)payload {
    [Smartlook trackCustomEventWithName:payload.event props:payload.properties];
    NSLog(@"track: '%@'\n%@", payload.event, payload.properties);
}


@end

// MARK: - Segment Integration Factory

@implementation SLSegmentIntegrationFactory

+ (instancetype)instance {
    static dispatch_once_t once = 0;
    static SLSegmentIntegrationFactory *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [SLSegmentIntegrationFactory new];
    });
    NSLog(@"segmentIntegrationFactory");
    return sharedInstance;
}

- (NSString *)key {
    NSLog(@"key");
    return @"Mixpanel";
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics {
    NSLog(@"createWithSettings %@ %@", settings, analytics);
    return [SLSegmentIntegration new];
}

@end
