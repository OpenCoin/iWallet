//
//  OCBase64.h
//  OpenCoinWallet
//
//  Created by Gulliver on 10.03.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCBase64 : NSObject

+(NSInteger) encode:(NSData*)input into:(NSString*) encoded;
+(NSInteger) decode:(NSString*) input into:(NSData*) decoded;

+(NSUInteger) enclen:(NSUInteger) l;
+(NSUInteger) declen:(NSUInteger) l;

@end
