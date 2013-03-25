//
//  OCCurrency.m
//  OpenCoinWallet
//
//  Created by Gulliver on 07.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import "OCCurrency.h"
#import "OCPublicKey.h"
#import "OCHttpClient.h"

@interface OCCurrency ()
@property OCHttpClient* client;
@property(readwrite) NSArray* mintKeys;
@end

@implementation OCCurrency

NSMutableArray* registeredCurrencies = nil;

+ (NSArray*) currencies:(void (^)(OCCurrency* result, NSError *error)) block
{
  if (!registeredCurrencies)
  {
    registeredCurrencies = [[NSMutableArray alloc] initWithCapacity:3];
    
    [OCCurrency registerCurrency:[NSURL URLWithString:@"http://127.0.0.1:6789/" ] withCompletition:block];
    [OCCurrency registerCurrency:[NSURL URLWithString:@"https://mighty-lake-9219.herokuapp.com/gulden/" ] withCompletition:block];
    
  }
  return registeredCurrencies;
}

+ (void) registerCurrency: (NSURL*) issuerURL withCompletition:(void (^)(OCCurrency* result, NSError *error)) block
{
  OCHttpClient* client = [[OCHttpClient alloc] initWithBaseURL:issuerURL];
  
  // This does not work on the server for now
  //[client getLatestCDD:^(OCCurrency *result, NSError *error) {
  
  [client getCDDSerial:^(NSNumber *serial, NSError *error) {
    if (!error)
    {
      [client getCDD:serial success:^(OCCurrency *result, NSError *error) {
        if (!error)
        {
          [registeredCurrencies addObject:result];
          result.client = client;
        }

        // call completion handler in any case
        if (block)
          block(result,error);
        }];
    }
    else if (block)
    {
        block(nil,error);
    }
  }];
}


- (id)initWithAttributes:(NSDictionary *)attributes
{
  self = [super init];
  if (!self) {
    return nil;
  }
  
  _additional_info  = [attributes valueForKeyPath:@"additional_info"];
  _cdd_expiry_date  = [attributes valueForKeyPath:@"cdd_expiry_date"];
  
  _cdd_location = [attributes valueForKeyPath:@"cdd_location"];
  _cdd_serial = [[attributes valueForKeyPath:@"cdd_serial"] integerValue];
  // TODO date conversion
  _cdd_signing_date = [NSDate date];
  // _cdd_signing_date = [attributes valueForKeyPath:@"cdd_signing_date"];
  
  _currency_divisor = [[attributes valueForKeyPath:@"currency_divisor"] integerValue];
  _currency_name = [attributes valueForKeyPath:@"currency_name"];
  _denominations =  [attributes valueForKeyPath:@"denominations"];
  
  // TODO read url list
  _info_service = [attributes valueForKeyPath:@"info_service"];
  // TODO read url list
  _invalidation_service = [attributes valueForKeyPath:@"invalidation_service"];
  
  _issuer_cipher_suite = [attributes valueForKeyPath:@"issuer_cipher_suite"];
  
  // TODO implement its subkeys
  _issuer_public_master_key = [[OCPublicKey alloc] initWithAttributes:[attributes valueForKeyPath:@"issuer_public_master_key"]];
  _protocol_version = [attributes valueForKeyPath:@"protocol_version"];
  _renewal_service = [attributes valueForKeyPath:@"renewal_service"];
  _validation_service = [attributes valueForKeyPath:@"validation_service"];
  
  return self;
  
}

@synthesize mintKeys=_mintKeys;

-(NSArray*) mintKeys
{
  if (!_mintKeys) {
    [_client getMintKeys:^(NSArray *result, NSError *error) {
      _mintKeys = result;
    }];
  }
  return _mintKeys;
}

-(void)setMintKeys:(NSArray *)mintKeys
{
  _mintKeys = mintKeys;
}



@end
