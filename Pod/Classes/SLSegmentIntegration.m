//
//  Smartlook+Segment.m
//  Smartlook
//
//  Created by Pavel Kroh on 26/05/2020.
//  Copyright © 2020 Smartsupp.com, s.r.o. All rights reserved.
//

#import "SLSegmentIntegration.h"

// MARK: - Segment Integration Object
@interface SLSegmentIntegration : NSObject<SEGIntegration>

- (void)track:(SEGTrackPayload *)payload;

@end

@implementation SLSegmentIntegration

- (void)track:(SEGTrackPayload *)payload {
    NSMutableDictionary *ammendedProperties = [NSMutableDictionary new];
    if (payload.properties != nil) {
        [ammendedProperties addEntriesFromDictionary:payload.properties];
    }
    [ammendedProperties setValue:@"segment" forKey:@"sl-origin"];
    [Smartlook trackCustomEventWithName:payload.event props:ammendedProperties];
}

- (void)screen:(SEGScreenPayload *)payload {
    NSMutableDictionary *ammendedProperties = [NSMutableDictionary new];
    if (payload.category) {
        [ammendedProperties setObject:payload.category forKey:@"category"];
    }
    if (payload.properties != nil) {
        [ammendedProperties addEntriesFromDictionary:payload.properties];
    }
    [ammendedProperties setValue:@"segment" forKey:@"sl-origin"];
    [Smartlook trackNavigationEventWithControllerId:payload.name type:SLNavigationTypeEnter];
}

- (void)reset {
    [Smartlook resetSessionAndUser:YES];
}

- (void)identify:(SEGIdentifyPayload *)payload {
    NSString *userId = payload.userId.length > 0 ? payload.userId : payload.anonymousId;
    if (userId.length > 0) {
        [Smartlook setUserIdentifier:userId];
    };
    [payload.traits enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [Smartlook setSessionPropertyValue:[NSString stringWithFormat:@"%@", obj] forName:key];
    }];
}

- (void)alias:(SEGAliasPayload *)payload {
    if (payload.theNewId.length > 0) {
        [Smartlook setUserIdentifier:payload.theNewId];
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
#warning DEBUG Segment Integration Key used.
    return @"Mixpanel";
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
            });
        } else {
            NSLog(@"Smartlook did not obtain API key from Segment. It will not be started by Segment.");
        }
    }
    return [SLSegmentIntegration new];
}

@end
