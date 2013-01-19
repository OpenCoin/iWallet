//
//  OCPublicKey.h
//  OpenCoinWallet
//
//  Created by Gulliver on 15.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCPublicKey : NSObject
- (id)initWithAttributes:(NSDictionary *)attributes;

@property(readonly)  NSString* modulus;
@property(readonly)  NSString* public_exponent;

@end
