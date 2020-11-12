//
//  SLSegmentSourceMiddleware.h
//  Segment-Smartlook
//
//  Created by Pavel Kroh on 12/11/2020.
//

#import <Smartlook/Smartlook.h>
#import <Analytics/SEGAnalytics.h>
#import <Analytics/SEGMiddleware.h>

#ifndef SLSegmentSourceMiddleware_h
#define SLSegmentSourceMiddleware_h

typedef NS_OPTIONS(NSUInteger, SLSegmentMiddlewareOptions) {
    SLSegmentMiddlewareTrackOption = 1 << 0,
    SLSegmentMiddlewareScreenOption = 1 << 1,
    SLSegmentMiddlewareIdentifyOption = 1 << 2,
    SLSegmentMiddlewareAliasOption = 1 << 3,
    SLSegmentMiddlewareResetOption = 1 << 4,
    SLSegmentMiddlewareAllOptions = 0xFF,
    SLSegmentMiddlewareDefaultOptions = SLSegmentMiddlewareAllOptions & ~SLSegmentMiddlewareScreenOption,
};


@interface SLSegmentSourceMiddleware : SEGBlockMiddleware

- (instancetype)initMiddlewareWithOptions:(SLSegmentMiddlewareOptions)options;

@end

#endif /* SLSegmentSourceMiddleware_h */
