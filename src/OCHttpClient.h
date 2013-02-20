//
//  OCHttpClient.h
//  OpenCoinWallet
//
//  Created by Gulliver on 14.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCCurrency;

@interface OCHttpClient : NSObject

+(OCHttpClient*) clientWithBaseURL:(NSURL*) url;

@property(readonly) NSURL* baseURL;

-(id)initWithBaseURL:(NSURL*) url;

-(void) getCDDSerial: (void (^)(NSNumber* serial, NSError *error))block;

-(void) getLatestCDD: (void (^)(OCCurrency* result, NSError *error))block;
-(void) getCDDbySerial:(NSInteger)serial              success:(void (^)(OCCurrency* result, NSError *error))block;

-(void) getMintKeys: (void (^)(NSArray* result, NSError *error))block;
-(void) getMintKeysByGet: (void (^)(NSArray* result, NSError *error))block;
-(void) getMintKeyWithIdByGet:(NSInteger)keyID            success:(void (^)(NSArray* result, NSError *error))block;
-(void) getMintKeysWithDenominationByGet:(NSInteger)serial success:(void (^)(NSArray* result, NSError *error))block;

-(void)   validateBlanks:(NSArray*) blanks
    WithMessageReference: (NSInteger) messageRef
withTransactionReference: (NSInteger) transactionRef
   WithAuthorisationInfo: (NSString*) authInfo
                 success:(void (^)(NSArray* result, NSError *error))block;

-(void)            renewalCoins: (NSArray*) coins
           withBlinds: (NSArray*) blinds
           withMessageReference: (NSInteger) messageRef
       withTransactionReference: (NSInteger) transactionRef
          withAuthorisationInfo: (NSString*) authInfo
                        success:(void (^)(NSArray* result, NSError *error))block;

@end
