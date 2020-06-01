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

@end

// MARK: - Segment Integration Factory

@implementation SLSegmentIntegrationFactory

+(instancetype)instance {
    NSLog(@"  ");
    NSLog(@" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *");
    NSLog(@"  ");
    NSLog(@"  SEGMENT - SMARTLOOK - INTEGRATION");
    NSLog(@"  ");
    NSLog(@"  This is a skeleton implementation that does no actual work.");
    NSLog(@"  Check for latest news about production version at: https://github.com/smartlook/segment-smartlook-ios/");
    NSLog(@"  ");
    NSLog(@" * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *");
    NSLog(@"  ");
    return [SLSegmentIntegrationFactory new];
}

- (nonnull id<SEGIntegration>)createWithSettings:(nonnull NSDictionary *)settings forAnalytics:(nonnull SEGAnalytics *)analytics {
    return [SLSegmentIntegration new];
}

- (nonnull NSString *)key {
    return @"Smartlook";
}

@end
