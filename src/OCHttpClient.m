//
//  OCHttpClient.m
//  OpenCoinWallet
//
//  Created by Gulliver on 14.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import "OCHttpClient.h"

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface OCHttpClient()

@property(readonly) AFHTTPClient* client;

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
    _client = [AFHTTPClient clientWithBaseURL:url];
    [_client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [_client setDefaultHeader:@"Accept" value:@"application/json"];
  }
  return self;
}

// common part of cdd requesting
-(void) getCDD:(NSString*) req
       success:(void (^)(OCCurrency* result, NSError *error))block
{
  [self.client getPath:req
            parameters:nil
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"%@", responseObject);
                 
                 if (block)
                 {
                   OCCurrency* c = [[OCCurrency alloc] initWithAttributes: [responseObject valueForKeyPath:@"cdd"]];
                   block(c,nil);
                 }
               }
   
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"error %@", [error localizedDescription]);
                 if (block)
                 {
                   block(nil,error);
                 }
                 
               }];
}

-(void) getLatestCDD:(void (^)(OCCurrency* result, NSError *error))block
{
  [self getCDD:@"cdds/latest" success:block];
}

-(void) getCDDbySerial:(NSInteger)serial
               success:(void (^)(OCCurrency* result, NSError *error))block
{
  [self getCDD:[NSString stringWithFormat:@"cdds/serial/%d",serial]
       success:block];
}

-(void) getMintKeys:(NSString*) req
            success:(void (^)(NSArray* result, NSError *error))block
{
  [self.client getPath:req
            parameters:nil
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"%@", responseObject);
                 
                 if (block)
                 {
                   //                   OCCurrency* c = [[OCCurrency alloc] initWithAttributes: [responseObject valueForKeyPath:@"cdd"]];
                   // block(c,nil);
                 }
               }
   
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"error %@", [error localizedDescription]);
                 if (block)
                 {
                   block(nil,error);
                 }
                 
               }];
  
}

-(void) getMintKeys: (void (^)(NSArray* result, NSError *error))block
{
  [self getMintKeys:@"mintkeys/" success:block];
}

-(void) getMintKeyWithId:(NSInteger)keyId
                 success:(void (^)(NSArray* result, NSError *error))block
{
  [self getMintKeys:[NSString stringWithFormat:@"mintkeys/id/%d",keyId]
            success:block];
}

-(void) getMintKeysWithDenomination:(NSInteger)denomination
                            success:(void (^)(NSArray* result, NSError *error))block
{
  [self getMintKeys:[NSString stringWithFormat:@"mintkeys/denomination/%d",denomination]
            success:block];
}




@end
