//
//  OCMintKey.m
//  OpenCoinWallet
//
//  Created by Gulliver on 14.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import "OCMintKey.h"
#import "OCPublicKey.h"

@implementation OCMintKey

- (id)initWithAttributes:(NSDictionary *)attributes
{
  self = [super init];
  if (!self) {
    return nil;
  }
  
  _id                    = [attributes valueForKeyPath:@"id"];
  _issuer_id             = [attributes valueForKeyPath:@"issuer_id"];
  _cdd_serial            = [[attributes valueForKeyPath:@"cdd_serial"] integerValue];
  _public_mint_key       = [[OCPublicKey alloc] initWithAttributes:[attributes valueForKeyPath:@"public_mint_key"]];
  _denomination          = [[attributes valueForKeyPath:@"denomination"] integerValue];
  _sign_coins_not_before = [attributes valueForKeyPath:@"sign_coins_not_before"];
  _sign_coins_not_after  = [attributes valueForKeyPath:@"sign_coins_not_after"];
  _coins_expiry_date     = [attributes valueForKeyPath:@"coins_expiry_date"];
  
  return self;
}

@end
