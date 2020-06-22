//
//  Smartlook+Segment.m
//  Smartlook
//
//  Created by Pavel Kroh on 26/05/2020.
//  Copyright © 2020 Smartsupp.com, s.r.o. All rights reserved.
//

#import "SLSegmentIntegration.h"
#import <Analytics/SEGAnalyticsUtils.h>

// MARK: - Segment Integration Object
@interface SLSegmentIntegration : NSObject<SEGIntegration>

@end

@implementation SLSegmentIntegration

- (void)track:(SEGTrackPayload *)payload {
    NSMutableDictionary *amendedProperties = [NSMutableDictionary new];
    if (payload.properties != nil) {
        [amendedProperties addEntriesFromDictionary:payload.properties];
    }
    [amendedProperties setValue:@"segment" forKey:@"sl-origin"];
    [Smartlook trackCustomEventWithName:payload.event props:amendedProperties];
    SEGLog(@"SEGMENT SMARTLOOK: track\n  event:'%@'\n  properties:%@", payload.event, amendedProperties);
}

- (void)screen:(SEGScreenPayload *)payload {
    [Smartlook trackNavigationEventWithControllerId:payload.name type:SLNavigationTypeEnter];
    SEGLog(@"SEGMENT SMARTLOOK: track\n  screen:'%@'", payload.name);
}

- (void)reset {
    [Smartlook resetSessionAndUser:YES];
}

- (void)identify:(SEGIdentifyPayload *)payload {
    if (payload.userId.length > 0) {
        [Smartlook setUserIdentifier:payload.userId];
    } else if (payload.anonymousId.length > 0) {
        [Smartlook setUserIdentifier:payload.anonymousId];
    } else {
        SEGLog(@"SEGMENT SMARTLOOK: cannot identify user with no userId or anonymousId");
        return;
    }
    if (payload.userId.length == 0 && payload.anonymousId.length > 0) {
        [Smartlook setSessionPropertyValue:[NSString stringWithFormat:@"%@", payload.anonymousId] forName:@"anonymous_id"];
    }
    [payload.traits enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [Smartlook setSessionPropertyValue:[NSString stringWithFormat:@"%@", obj] forName:key];
    }];
    SEGLog(@"SEGMENT SMARTLOOK: identify\n  user:'%@'\n  properties:%@", payload.userId, payload.traits);
}

- (void)alias:(SEGAliasPayload *)payload {
    if (payload.theNewId.length > 0) {
        [Smartlook setUserIdentifier:payload.theNewId];
        SEGLog(@"SEGMENT SMARTLOOK: alias\n  user:'%@'", payload.theNewId);
    } else {
        SEGLog(@"SEGMENT SMARTLOOK: cannot re-identify user with no id");
    }
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
    return sharedInstance;
}

- (NSString *)key {
    return @"Smartlook";
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics {
    // when complex Smartlook setup is required, it must be setup and run before Segment initialization
    // and it is already running now
    if (![Smartlook isRecording]) {
        NSString *smartlookAPIKey = [settings valueForKey:@"API_KEY"];
        if ([smartlookAPIKey isKindOfClass:[NSString class]] && smartlookAPIKey.length > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Smartlook setupWithKey:smartlookAPIKey];
                [Smartlook startRecording];
                SEGLog(@"SEGMENT SMARTLOOK: did setup and start");
            });
        } else {
            NSLog(@"SEGMENT SMARTLOOK: did not obtain API key from Segment. It will not be started by Segment. If you want setting up Smartlook manually, do it BEFORE setting up Segment.");
        }
    } else {
        SEGLog(@"SEGMENT SMARTLOOK: already running, no need to setup");
    }
    return [SLSegmentIntegration new];
}

@end
