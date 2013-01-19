//
//  OCPublicKey.m
//  OpenCoinWallet
//
//  Created by Gulliver on 15.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import "OCPublicKey.h"

@implementation OCPublicKey

- (id)initWithAttributes:(NSDictionary *)attributes
{
  self = [super init];
  if (!self) {
    return nil;
  }

  _modulus  = [attributes valueForKeyPath:@"modulus"];;
  _public_exponent  = [attributes valueForKeyPath:@"public_exponent"];;
  
  return self;
  
}

@end
