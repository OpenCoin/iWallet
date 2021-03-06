//
//  OCBlank.m
//  OpenCoinWallet
//
//  Created by Gulliver on 15.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import "OCBlank.h"

#import "OCCurrency.h"
#import "OCMintKey.h"
#import "OCPublicKey.h"

@implementation OCBlank

- (id)initWithAttributes:(NSDictionary *)attributes
{
  self = [super init];
  if (!self) {
    return nil;
  }
  
  
  return self;
}

+(OCBlank*) blankWithCurrency: (OCCurrency*) currency
             WithDenomination: (NSInteger) denomination
                  WithMintKey: (OCMintKey*) mint_key
{
  OCBlank* blank;
  if (!currency ||!mint_key)
  {
    blank = nil;
  }
  else
  {
    blank = [[OCBlank alloc] init];
    blank.protocol_version = currency.protocol_version;
    blank.issuer_id        = currency.issuer_public_master_key.public_exponent;        // = base64(hash(public master key))
    blank.cdd_location     = currency.cdd_location;        // = http://opencent.net/OpenCent [[Hint to download the CDD if not available anyway.
                                                           // Useful for clients        to "bootstrap" a yet unknown currency.]]
    blank.denomination     = denomination;   // = integer [[Only a hint, not verified value. Denomination MUST be verified by checking the mint key's denomination.]]
    blank.mint_key_id      = mint_key.id; //@"PWk9saAOHwXgUFTEaxpZWGHRKm8pGrL9o+xS3CjEToZfooirTKVu283sGlco58VBaapgzlmCcZQo\npZqL+4sp3yeTotYfBfq1nPLgEmInsLh16uHv4GCw4xIPhME5HLM3BHp9zNvrqo3z/4a2qEZ43Qz9\nJCAlWrDo/MCE+N/GOWWQgttbhnKN9UmmYUStWW8J7sRBPUKVkubahI4eA2tkFz02oip8AxDKZd/b\na5qFPrSDmNhN3nL7pMPOmddg5FMNNbHyHxZbNvUimRcmWYNURjGTNwvNebRaoUDmd28F1QGSkCJE\nAqdZwzN0XoZ6BLJjOCWCrM2HIRL+Xp+oHGEsww==";
    
    //mint_key.public_mint_key.public_exponent;      // = base64(hash(public mint key))
    blank.serial           = @"23";           // = base64(128bit random number) [[This random value is generated by clients.
                                              // A high entropy (crypto grade quality) is important.]]
  
  }
  return blank;
}

#define ENTRY(name) [[self name] description], #name
#define INTEGER_ENTRY(name) [[NSNumber numberWithInt:self.name] description], #name

-(NSDictionary*) toDictionary
{
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [self protocol_version] , @"protocol_version"
                        ,   [self issuer_id] , @"issuer_id"
                        ,   [self cdd_location] , @"cdd_location"
                        ,   [NSNumber numberWithInteger:[self denomination] ] , @"denomination"
                        ,   [self mint_key_id] , @"mint_key_id"
                        ,   [self serial] , @"serial"
                        
  /*, ENTRY(protocol_version)
                        , ENTRY(issuer_id)
                        , ENTRY(cdd_location)
                        , INTEGER_ENTRY(denomination)
                        , ENTRY(mint_key_id)
                        , ENTRY(serial)
                        */
                        , nil];
  return dict;
}

- (NSDictionary*) blindedHash
{
// TODO calculate reference (dont use serial or something like)
// TODO calculate blinded hash
  NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"blank0" , @"reference"
                        ,   @"2aed4b188576b94f8898909d8e75707dc7a48951579508930a946a4acd5454e87" , @"blinded_payload_hash"
                        ,   [self mint_key_id] , @"mint_key_id"
                        ,   @"blinded payload hash" , @"type"
                        , nil];
  return dict;
}

@end
