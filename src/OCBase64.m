//
//  OCBase64.m
//  OpenCoinWallet
//
//  Created by Gulliver on 10.03.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import "OCBase64.h"

#include "base64.h"

@implementation OCBase64

+(NSInteger) encode:(NSData*)input into:(NSString*) encoded
{
  if (!input)
  {
    return -1;
  }
  else
  {
    size_t buflen = base64_enclen(input.length);
    char * buf = malloc(buflen);
    
    int result = base64_encode(input.bytes,input.length,
                               buf,buflen);
    
    encoded = [[NSString alloc] initWithBytesNoCopy: buf
                                             length: buflen
                                           encoding: NSASCIIStringEncoding
                                       freeWhenDone: YES];
    return result;
  }
}

+(NSInteger) decode:(NSString*) input into:(NSData*) decoded;
{
  if (!input)
  {
    return -1;
  }
  else
  {
    size_t buflen = base64_declen(input.length);
    uint8_t* buf = malloc(buflen);
    
    int result = base64_decode(input.UTF8String,buf,buflen);
    
    decoded = [[NSData alloc] initWithBytesNoCopy: buf
                                           length: buflen
                                     freeWhenDone: YES];
    return result;
  }
}

+(NSUInteger) enclen:(NSUInteger) l
{
  return base64_enclen(l);
}

+(NSUInteger) declen:(NSUInteger) l
{
  return base64_declen(l);
}


@end
