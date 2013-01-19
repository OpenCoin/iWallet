//
//  OCCurrency.h
//  OpenCoinWallet
//
//  Created by Gulliver on 07.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCPublicKey;

@interface OCCurrency : NSObject

@property(readonly)  NSString*  additional_info;
  
@property(readonly)  NSDate*    cdd_expiry_date; //" = "2013-12-31T00:00:00.000+0000";
@property(readonly)  NSURL*  cdd_location; // = "https://mighty-lake-9219.herokuapp.com/gulden/cdds/serial/2342";
@property(readonly)  NSInteger cdd_serial; // = 2342;
@property(readonly)  NSDate*    cdd_signing_date; // = "2012-11-11T00:00:00.000+0000";
@property(readonly)  NSInteger currency_divisor; // = 1;
@property(readonly)  NSString*  currency_name; //" = Gulden;
@property(readonly)  NSArray*   denominations;

@property(readonly)  NSArray*   info_service;

@property(readonly)  NSArray*   invalidation_service;
@property(readonly)  NSString*  issuer_cipher_suite; // = "SHA256-RSA2048-CHAUM83";
@property(readonly)  OCPublicKey*  issuer_public_master_key;
/*
 =         {
    modulus = "AOn1CVCNUpGeoF/FGAXqqNcYFcoafBcakeQQnlyh74o4EUGkaXjb9Ua0DYvOD4/Ey16LZFPJ58jc\nSI/IE6YvxCiqDuU4m8EBp2lEVz2vDIggyj2QY6ZYkxzzmot/U2Tls9CkEvvLc4SHGYoT7qpgyrZh\n8EjOgqDzjXPzG+CErwpklHNdAxK8pZFB3uUoJJqSmL6noQqYN28bkPKb3WpFgvImwOfJn+pBS+4Z\nsuX4zs5Fhb9e/4qdcDwmCYm1zZZfXg1CYWnXOMYePymM8CYixL6MphBH/qVIddRJVQiMJFMjz6FL\nEpc/GoTjZlu65ikivCVF0dgaKeQBWt8Y3QacMOs=";
    "public_exponent" = AQAB;
  };
*/
@property(readonly) NSURL*     protocol_version; // = "http://okfnpad.org/opencoin-v3";
@property(readonly) NSArray*   renewal_service;
@property(readonly) NSArray*   validation_service;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
