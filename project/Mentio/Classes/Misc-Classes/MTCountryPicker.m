//
//  MTCountryPicker.m
//  Mentio
//
//  Created by Martin Hartl on 12/03/14.
//  Copyright (c) 2014 Martin Hartl. All rights reserved.
//

#import "MTCountryPicker.h"
#import <CountryPicker/CountryPicker.h>

@interface MTCountryPicker ()

@property (nonatomic, strong) NSArray *countryCodes;

@end

@implementation MTCountryPicker

+ (instancetype)sharedInstance {
    static MTCountryPicker *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MTCountryPicker alloc] init];
    });
    
    return _sharedInstance ;
}

- (instancetype)init {
    self = [super init];
    if (self) {
                          
    }
    return self;
}

+ (NSArray *)countryCodes {
    
    NSArray *countryCodes = @[@"AI",
                      @"AG",
                      @"AM",
                      @"AR",
                      @"AT",
                      @"AZ",
                      @"BS", @"BH", @"BY", @"BE", @"BZ", @"BO", @"BW",
                      @"BR", @"VG", @"BN", @"BG",
                      @"CA", @"CV", @"KY", @"CL", @"CO", @"CR", @"CY", @"CZ",
                      @"DK", @"DM", @"DO",
                      @"EC", @"EG", @"SV", @"EE",
                      @"FI", @"FJ", @"FR",
                      @"GM", @"DE", @"GH", @"GR", @"GD", @"GT", @"GW",
                      @"HN", @"HK", @"HU",
                      @"IS", @"IN", @"ID", @"IE", @"IL", @"IT",
                      @"JM", @"JP", @"JO",
                      @"KR",
                      @"LV", @"LB", @"LB", @"LI", @"LT", @"LU",
                      @"MO", @"MG", @"MY", @"MT", @"MU", @"MX", @"FM", @"MD", @"MN", @"MZ",
                      @"NA", @"NL", @"NZ", @"NI", @"NE", @"NO",
                      @"OM", @"PA", @"PY", @"PE", @"PH", @"PL", @"PT",
                      @"QA",
                      @"RO", @"RU",
                      @"KN", @"SA", @"SG", @"SK", @"SI", @"ZA", @"ES", @"LK", @"SZ", @"SE", @"CH",
                      @"TW", @"TJ", @"TH", @"TT", @"TR", @"TM",
                      @"UG", @"UA", @"AE", @"GB", @"US",
                      @"VE", @"VN",
                      @"ZW"];
    countryCodes = [countryCodes sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return countryCodes;
}

+ (NSArray *)countryNames {
    NSDictionary *countrNamesByCode = [CountryPicker countryNamesByCode];
    NSArray *countyCodes = [self countryCodes];
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *countryCode in countyCodes) {
        
        if (countrNamesByCode[countryCode]) {
            [array addObject:countrNamesByCode[countryCode]];
        }
    }
    return [NSArray arrayWithArray:array];
}

@end
