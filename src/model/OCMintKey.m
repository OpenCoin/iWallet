//
//  OCMintKey.m
//  OpenCoinWallet
//
//  Created by Gulliver on 14.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import "OCMintKey.h"

@implementation OCMintKey
- (id)initWithAttributes:(NSDictionary *)attributes
{
  self = [super init];
  if (!self) {
    return nil;
  }
  
//  _additional_info  = [attributes valueForKeyPath:@"additional_info"];
//  _cdd_expiry_date  = [attributes valueForKeyPath:@"cdd_expiry_date"];
//  
//  _cdd_location = [attributes valueForKeyPath:@"cdd_location"];
//  _cdd_serial = [[attributes valueForKeyPath:@"cdd_serial"] integerValue];
//  // TODO date conversion
//  // _cdd_signing_date = [attributes valueForKeyPath:@"cdd_signing_date"];
//  
//  _currency_divisor = [[attributes valueForKeyPath:@"currency_divisor"] integerValue];
//  _currency_name = [attributes valueForKeyPath:@"currency_name"];
//  _denominations =  [attributes valueForKeyPath:@"denominations"];
//  
//  // TODO read url list
//  _info_service = [attributes valueForKeyPath:@"info_service"];
//  // TODO read url list
//  _invalidation_service = [attributes valueForKeyPath:@"invalidation_service"];
//  
//  _issuer_cipher_suite = [attributes valueForKeyPath:@"issuer_cipher_suite"];
//  
//  // TODO implement its subkeys
//  _issuer_public_master_key = [attributes valueForKeyPath:@"issuer_public_master_key"];
//  _protocol_version = [attributes valueForKeyPath:@"protocol_version"];
//  _renewal_service = [attributes valueForKeyPath:@"renewal_service"];
//  _validation_service = [attributes valueForKeyPath:@"validation_service"];
  
  return self;
  
}

@end
