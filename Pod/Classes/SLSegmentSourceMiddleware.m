//
//  SLSegmentSourceMiddleware.m
//  Segment-Smartlook
//
//  Created by Pavel Kroh on 12/11/2020.
//

#import "SLSegmentSourceMiddleware.h"

@interface SLSegmentSourceMiddleware ()

@end

@implementation SLSegmentSourceMiddleware

- (instancetype)initMiddlewareWithOptions:(SLSegmentMiddlewareOptions)options {
    return [super initWithBlock:^(SEGContext * _Nonnull context, SEGMiddlewareNext  _Nonnull next) {
        
        switch (context.eventType) {
                
            case SEGEventTypeTrack:
                if (options & SLSegmentMiddlewareTrackOption) {
                    SEGTrackPayload *trackPayload = (SEGTrackPayload *)context.payload;
                    [Smartlook trackCustomEventWithName:trackPayload.event props:trackPayload.properties];
                }
                break;
                
            case SEGEventTypeScreen:
                if (options & SLSegmentMiddlewareScreenOption) {
                    SEGScreenPayload *screenPayload = (SEGScreenPayload *)context.payload;
                    [Smartlook trackNavigationEventWithControllerId:screenPayload.name type:SLNavigationTypeEnter];
                }
                break;

            case SEGEventTypeIdentify:
                if (options & SLSegmentMiddlewareIdentifyOption) {
                    SEGIdentifyPayload *identifyPayload = (SEGIdentifyPayload *)context.payload;
                    
                    if (identifyPayload.userId.length > 0) {
                        [Smartlook setUserIdentifier:identifyPayload.userId];
                    } else if (identifyPayload.anonymousId.length > 0) {
                        [Smartlook setUserIdentifier:identifyPayload.anonymousId];
                    }
                    
                    if (identifyPayload.traits.count > 0) {
                        [identifyPayload.traits enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
                            [Smartlook setSessionPropertyValue:value forName:key];
                        }];
                    }

                }
                break;

            case SEGEventTypeAlias:
                if (options & SLSegmentMiddlewareAliasOption) {
                    SEGAliasPayload *aliasPayload = (SEGAliasPayload *)context.payload;
                    
                    if (aliasPayload.theNewId.length > 0) {
                        [Smartlook setUserIdentifier:aliasPayload.theNewId];
                    }

                }
                break;

            case SEGEventTypeReset:
                if (options & SLSegmentMiddlewareResetOption) {
                    [Smartlook resetSessionAndUser:YES];
                }
                break;
                
            default:
                break;
        }
        
        next(context);
    }];
}

@end
