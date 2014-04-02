//
//  OCHttpClient.m
//  OpenCoinWallet
//
//  Created by Gulliver on 14.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import "OCHttpClient.h"

#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"

#import "OCBlank.h"
#import "OCCurrency.h"
#import "OCMintKey.h"
#import "OCBlindSignature.h"

@interface OCHttpClient()

@property(readonly) AFHTTPSessionManager* client;

@end

@implementation OCHttpClient

+(OCHttpClient*) clientWithBaseURL:(NSURL*) url
{
  // TODO cache clients in dictionary with key url
  return [[OCHttpClient alloc] initWithBaseURL:url];
}

-(id)initWithBaseURL:(NSURL*) url
{
  self = [super init];
  if (self)
  {
    _client = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    
    AFJSONRequestSerializer* s = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    [s setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_client setRequestSerializer:s];
    
    [_client setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:0]];
  }
  return self;
}

-(void) getCDDSerial: (void (^)(NSNumber* serial, NSError *error))block
{
  NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[NSNumber numberWithInt:0] description] , @"message_reference"
                          , @"request cdd serial"                    , @"type"
                          , nil];
  
  [self.client POST:@"/"
             parameters:param
                success:^(NSURLSessionDataTask *operation, id responseObject) {
                  if (block)
                  {
                    NSNumber *result=nil;
                    NSLog(@"response : %@",responseObject);
                    result = [responseObject valueForKey:@"cdd_serial"];
                    block(result,nil);
                  }
                }
                failure:^(NSURLSessionDataTask *operation, NSError *error) {
                  if (block)
                    block(nil,error);
                  NSLog(@"error %@",[error localizedDescription]);
                }
   ];
  
}

-(void) getCDD:(NSNumber*) serial success:(void (^)(OCCurrency* result, NSError *error))block
{
  NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                         [[NSNumber numberWithInt:0] description] , @"message_reference"
                         , @"request cdd"                    , @"type"
                         , serial , @"cdd_serial"
                         , nil];
  
  [self.client POST:@"/"
             parameters:param
                success:^(NSURLSessionDataTask *operation, id responseObject) {
                 NSLog(@"%@", responseObject);
                 
                 if (block)
                 {
                   OCCurrency* c = [[OCCurrency alloc] initWithAttributes: [responseObject valueForKeyPath:@"cdd.cdd"]];
                   block(c,nil);
                 }
               }
   
               failure:^(NSURLSessionDataTask *operation, NSError *error) {
                 NSLog(@"error %@", [error localizedDescription]);
                 if (block)
                 {
                   block(nil,error);
                 }
                 
               }];
}

-(void) getLatestCDD:(void (^)(OCCurrency* result, NSError *error))block
{
  return [self getCDD:nil success:block];
}

// common part of cdd requesting
-(void) getCDDByGet:(NSString*) req success:(void (^)(OCCurrency* result, NSError *error))block
{
  [self.client GET:req
            parameters:nil
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                 NSLog(@"%@", responseObject);
                 
                 if (block)
                 {
                   OCCurrency* c = [[OCCurrency alloc] initWithAttributes: [responseObject valueForKeyPath:@"cdd"]];
                   block(c,nil);
                 }
               }
   
               failure:^(NSURLSessionDataTask *operation, NSError *error) {
                 NSLog(@"error %@", [error localizedDescription]);
                 if (block)
                 {
                   block(nil,error);
                 }
                 
               }];
}

-(void) getLatestCDDByGet:(void (^)(OCCurrency* result, NSError *error))block
{
  [self getCDDByGet:@"cdds/latest" success:block];
}

-(void) getCDDbySerial:(NSInteger)serial
               success:(void (^)(OCCurrency* result, NSError *error))block
{
  [self getCDDByGet:[NSString stringWithFormat:@"cdds/serial/%d",serial]
       success:block];
}

-(void) getMintKeys: (void (^)(NSArray* result, NSError *error))block
{
  NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"request mint keys"                     , @"type"
                         , [[NSNumber numberWithInt:0] description] , @"message_reference"
                         , nil];
  
  [self.client POST:@"/"
             parameters:param
                success:^(NSURLSessionDataTask *operation, id responseObject)
                {
                    if (block)
                    {
                      NSMutableArray* keys = [NSMutableArray array];
                      OCMintKey* k;
                      NSLog(@"%@",responseObject);
                      for (id item in [responseObject valueForKey:@"keys"])
                      {
                        k = [[OCMintKey alloc] initWithAttributes:[item valueForKeyPath:@"mint_key"]];
                        // TODO check signature;
                        [keys addObject:k];
                      }
                      block(keys,nil);
                    }
                }
   
                failure:^(NSURLSessionDataTask *operation, NSError *error) {
                  NSLog(@"error %@", [error localizedDescription]);
                  if (block)
                  {
                    block(nil,error);
                  }
                }
   ];
}

-(void) validateBlanks:(NSArray*) blanks WithMessageReference: (NSInteger) messageRef
                                     withTransactionReference: (NSInteger) transactionRef
                                        WithAuthorisationInfo: (NSString*) authInfo
                                                      success:(void (^)(NSArray* result, NSError *error))block
{
  NSMutableArray* convertedBlanks = [NSMutableArray arrayWithCapacity:[blanks count]];
  for(OCBlank* blank in blanks)
  {
    [convertedBlanks addObject:[blank blindedHash]];
  }
  
  NSMutableDictionary* param = [[NSMutableDictionary alloc] initWithCapacity:5];
  
  [param setObject: @"request validation"                       forKey:@"type"];
  [param setObject: [NSNumber numberWithInteger:messageRef]     forKey:@"message_reference"];
  [param setObject: [NSNumber numberWithInteger:transactionRef] forKey:@"transaction_reference"];
  [param setObject: authInfo                                    forKey:@"authorisation_info"];
  [param setObject: convertedBlanks                             forKey:@"blinds"];
  
  [self.client POST:@"/"
             parameters:param
                success:^(NSURLSessionDataTask *operation, id responseObject) {
                  if (block)
                  {
                    NSLog(@"%@",responseObject);
                    NSMutableArray* blind_signatures = [NSMutableArray array];
                    OCBlindSignature* blind;
                    for (id item in [responseObject valueForKeyPath:@"blind_signatures"])
                    {
                      blind = [[OCBlindSignature alloc] initWithAttributes:[item valueForKeyPath:@"mint_key"]];
                      // TODO check signature;
                      [blind_signatures addObject:blind];
                    }
                    block(blind_signatures,nil);
                  }
                }
                failure:^(NSURLSessionDataTask *operation, NSError *error) {
                  if (block)
                    block(nil,error);
                  NSLog(@"error %@",[error localizedDescription]);
                }
  ];
}

-(void)            renewalCoins: (NSArray*) coins
           withMessageReference: (NSInteger) messageRef
       withTransactionReference: (NSInteger) transactionRef
          withAuthorisationInfo: (NSString*) authInfo
                        success:(void (^)(NSArray* result, NSError *error))block
{
  NSMutableArray* convertedCoins = [NSMutableArray arrayWithCapacity:[coins count]];
  for(OCBlank* coin in coins)
  {
    [convertedCoins addObject:[coin toDictionary]];
  }
  
  NSMutableDictionary* param = [[NSMutableDictionary alloc] initWithCapacity:5];
  
  [param setObject: @"request validation"                       forKey:@"type"];
  [param setObject: [NSNumber numberWithInteger:messageRef]     forKey:@"message_reference"];
  [param setObject: [NSNumber numberWithInteger:transactionRef] forKey:@"transaction_reference"];
  [param setObject: authInfo                                    forKey:@"authorisation_info"];
  [param setObject: convertedCoins                              forKey:@"tokens"];
  
  [self.client POST:@"/"
             parameters:param
                success:^(NSURLSessionDataTask *operation, id responseObject) {
                  if (block)
                  {
                    NSLog(@"%@",responseObject);
                    NSMutableArray* blind_signatures = [NSMutableArray array];
                    OCBlindSignature* blind;
                    for (id item in [responseObject valueForKeyPath:@"blind_signatures"])
                    {
                      blind = [[OCBlindSignature alloc] initWithAttributes:[item valueForKeyPath:@"mint_key"]];
                      // TODO check signature;
                      [blind_signatures addObject:blind];
                    }
                    block(blind_signatures,nil);
                  }
                }
                failure:^(NSURLSessionDataTask *operation, NSError *error) {
                  if (block)
                    block(nil,error);
                  NSLog(@"error %@",[error localizedDescription]);
                }
   ];
}
  
-(void) getMintKeysByGet:(NSString*) req
                 success:(void (^)(NSArray* result, NSError *error))block
{
  [self.client GET:req
            parameters:nil
               success:^(NSURLSessionDataTask *operation, id responseObject) {
                 if (block)
                 {
                   NSMutableArray* keys = [NSMutableArray array];
                   OCMintKey* k;
                   for (id item in responseObject)
                   {
                     k = [[OCMintKey alloc] initWithAttributes:[item valueForKeyPath:@"mint_key"]];
                     // TODO check signature;
                     [keys addObject:k];
                   }
                   block(keys,nil);
                 }
               }
   
               failure:^(NSURLSessionDataTask *operation, NSError *error) {
                 NSLog(@"error %@", [error localizedDescription]);
                 if (block)
                 {
                   block(nil,error);
                 }
                 
               }];
}

-(void) getMintKeysByGet: (void (^)(NSArray* result, NSError *error))block
{
  [self getMintKeysByGet:@"mintkeys/" success:block];
}

-(void) getMintKeyWithIdByGet:(NSInteger)keyId
                      success:(void (^)(NSArray* result, NSError *error))block
{
  [self getMintKeysByGet:[NSString stringWithFormat:@"mintkeys/id/%d",keyId]
                 success:block];
}

-(void) getMintKeysWithDenominationByGet:(NSInteger)denomination
                                 success:(void (^)(NSArray* result, NSError *error))block
{
  [self getMintKeysByGet:[NSString stringWithFormat:@"mintkeys/denomination/%d",denomination]
                 success:block];
}


@end
