//
//  MWMapsHandlerSpec.m
//  MWOpenInKitTests
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "MWMapsHandler.h"
#import "MWApplicationList.h"
#import <MapKit/MapKit.h>

@interface MWMapsHandler (Spec)
@property UIApplication *application;
@property MWApplicationList *appList;
@end

SpecBegin(MWhandler)

describe(@"MWMapsHandler", ^{
    __block MWMapsHandler *handler;

    beforeEach(^{
        handler = [[MWMapsHandler alloc] init];
        handler.application = mock([UIApplication class]);
        handler.appList = [[MWApplicationList alloc] initWithApplication:handler.application];
    });

    describe(@"passing along optional variables", ^{
        context(@"the map center", ^{
            itShouldBehaveLike(@"an optional handler property", ^{
                return @{@"handler":  handler,
                         @"urlStringWithParam": @"http://maps.apple.com/?q=Roberto%27s&ll=32.715000,-117.162500",
                         @"subjectAction": [^{
                             handler.center = CLLocationCoordinate2DMake(32.715, -117.1625);
                             return [handler searchForLocation:@"Roberto's"];
                         } copy]};
            });
        });

        context(@"the map zoon", ^{
            itShouldBehaveLike(@"an optional handler property", ^{
                return @{@"handler":  handler,
                         @"urlStringWithParam": @"http://maps.apple.com/?q=Roberto%27s&z=5",
                         @"subjectAction": [^{
                             handler.zoom = 5;
                             return [handler searchForLocation:@"Roberto's"];
                         } copy]};
            });
        });
    });

    describe(@"Search query", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"http://maps.apple.com/?q=Roberto%27s",
                     @"subjectAction": [^{
                         return [handler searchForLocation:@"Roberto's"];
                     } copy]};
        });
    });

    describe(@"Turn-by-turn directions", ^{
        context(@"without a mode", ^{
            itShouldBehaveLike(@"a handler action", ^{
                return @{@"handler":  handler,
                         @"urlString": @"http://maps.apple.com/?saddr=New%20Jersey&daddr=California",
                         @"subjectAction": [^{
                             return [handler directionsFrom:@"New Jersey" to:@"California"];
                         } copy]};
            });
        });

        context(@"with a directions mode", ^{
            itShouldBehaveLike(@"a handler action", ^{
                return @{@"handler":  handler,
                         @"urlString": @"comgooglemaps://?saddr=New%20Jersey&daddr=California&directionsmode=walking",
                         @"subjectAction": [^{
                             return [handler directionsFrom:@"New Jersey" to:@"California" mode:MWMapsHandlerDirectionsModeWalking];
                         } copy]};
            });
        });
    });
});

SpecEnd