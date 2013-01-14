//
//  OCHttpClient.h
//  OpenCoinWallet
//
//  Created by Gulliver on 14.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCCurrency.h"

@interface OCHttpClient : NSObject

+(OCHttpClient*) clientWithBaseURL:(NSURL*) url;

@property(readonly) NSURL* baseURL;

-(id)initWithBaseURL:(NSURL*) url;

-(void) getLatestCDD:                                          (void (^)(OCCurrency* result, NSError *error))block;
-(void) getCDDbySerial:(NSInteger)serial              success:(void (^)(OCCurrency* result, NSError *error))block;

-(void) getMintKeys: (void (^)(NSArray* result, NSError *error))block;
-(void) getMintKeyWithId:(NSInteger)keyID            success:(void (^)(NSArray* result, NSError *error))block;
-(void) getMintKeysWithDenomination:(NSInteger)serial success:(void (^)(NSArray* result, NSError *error))block;

@end
