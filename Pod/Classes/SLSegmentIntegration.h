//
//  Smartlook+Segment.h
//  Smartlook
//
//  Created by Pavel Kroh on 26/05/2020.
//  Copyright © 2020 Smartsupp.com, s.r.o. All rights reserved.
//

#import <Smartlook/Smartlook.h>
#import <Analytics/SEGAnalytics.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLSegmentIntegrationFactory : NSObject <SEGIntegrationFactory>

+(instancetype)instance;

@end

NS_ASSUME_NONNULL_END
