//
//  OCMintKey.h
//  OpenCoinWallet
//
//  Created by Gulliver on 14.01.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCPublicKey;

@interface OCMintKey : NSObject
- (id)initWithAttributes:(NSDictionary *)attributes;

@property(readonly)  NSString*     id;                    // = base64(hash(public mint key))
                                                         // [[MUST be verified when receiving a mint_key. Why? Isn't the signature sufficient?]]
@property(readonly)  NSString*     issuer_id;             //  = base64(hash(public master key))
@property(readonly)  NSInteger     cdd_serial;            //  = integer [[Allows unique relation to CDD version but may be ignored by clients for now.]]
@property(readonly)  OCPublicKey*  public_mint_key ;      //   = JSON dict construct, depending on used crypto algorithm. base64(public mint key)
@property(readonly)  NSInteger     denomination;          //  = integer
@property(readonly)  NSDate*       sign_coins_not_before; //  = DATE TIME
@property(readonly)  NSDate*       sign_coins_not_after;  //  = DATE TIME
@property(readonly)  NSDate*       coins_expiry_date;     //  = DATE TIME

@end
