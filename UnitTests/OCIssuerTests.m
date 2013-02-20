//
//  OCIssuerTests.m
//  OpenCoinWallet
//
//  Created by Gulliver on 07.02.13.
//  Copyright (c) 2013 Opencoin Team. All rights reserved.
//

// For iOS
#import <GHUnitIOS/GHUnit.h>
// For Mac OS X
//#import <GHUnit/GHUnit.h>

#import <Foundation/NSURLConnection.h>

#import "OCHTTPClient.h"

#import "OCCurrency.h"
#import "OCBlank.h"

@interface OCIssuerTests : GHAsyncTestCase { }
@property(readonly) NSURL* LOCAL_URL;
@property(readonly) NSURL* VALID_URL;
@property(readonly) NSURL* INVALID_URL;


@end

@implementation OCIssuerTests

- (void)setUp
{
  [super setUp];
  _LOCAL_URL   = [NSURL URLWithString:@"http://127.0.0.1:6789/" ];
  _VALID_URL   = [NSURL URLWithString:@"https://mighty-lake-9219.herokuapp.com/gulden/" ];
  _INVALID_URL = [NSURL URLWithString:@"https://mighty-lake-9219.herokuapp.com/nullar/" ];
  
  // Set-up code here.
}

-(void) testGetCddSerial
{
  [self prepare];
  
  static NSNumber *serial;
  static NSError *error;
  
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.LOCAL_URL];
  [client getCDDSerial: ^(NSNumber *_serial, NSError *_error) {
     
     serial = _serial;
     error = _error;
     
     [self notify:kGHUnitWaitStatusSuccess];
   }];

  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNil( error,  @"no error awaited but got: %@",[error localizedDescription]);
  GHAssertNotNil(serial, @"no result returned: %@",serial);
}

-(void) xtestGetCddSerialFromJan
{
  [self prepare];
  
  static NSNumber *serial;
  static NSError *error;
  
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.VALID_URL];
  [client getCDDSerial: ^(NSNumber *_serial, NSError *_error) {
    
    serial = _serial;
    error = _error;
    
    [self notify:kGHUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNil( error,  @"no error awaited but got: %@",[error localizedDescription]);
  GHAssertNotNil(serial, @"no result returned: %@",serial);
}


-(void) testGetCurrencyByGetRequest
{
  [self prepare];
  
  static OCCurrency *result;
  static NSError *error;
    
  // test existing cdd
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.VALID_URL];
  [client getLatestCDD:^(OCCurrency *_result, NSError *_error) {
    result = _result;
    error = _error;
    [self notify:kGHUnitWaitStatusSuccess ];
  }
   ];
  
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];

  GHAssertNotNil(result, @"no currencies returned: %@",result);
  GHAssertNil(error, @"no error awaited but got: %@",[error localizedDescription]);
}

-(void) testGetCurrencyFromInValidURL
{
  [self prepare];
  
  static OCCurrency *result;
  static NSError *error;
  
  // test not existing cdd
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.INVALID_URL];
  [client getLatestCDD:^(OCCurrency *_result, NSError *_error) {
    result = _result;
    error = _error;
    [self notify:kGHUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNil(result, @"shoudn't return data on error : %@",result);
  GHAssertNotNil(error, @"error: %@",[error localizedDescription]);
}

-(void) testLoadMintKeysFromValidURL
{
  [self prepare];

  static NSArray *result;
  static NSError *error;
  
    // test existing url
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.LOCAL_URL];
  [client getMintKeys:^(NSArray *_result, NSError *_error) {
    result = _result;
    error = _error;
    [self notify:kGHUnitWaitStatusSuccess ];
   }];
  
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNotNil(result             , @"no mint keys returned: %@",result);
  GHAssertTrue ([result count] > 0 , @"no mint keys returned - array empty:");
  
  GHAssertNil   (error              , @"no error awaited but got: %@",[error localizedDescription]);
}

-(void) testLoadMintKeysFromNonvalidURL
{
  [self prepare];
  
  static NSArray *result;
  static NSError *error;
  
  // test existing url
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.INVALID_URL];
  [client getMintKeys:^(NSArray *_result, NSError *_error) {
    result = _result;
    error = _error;
    [self notify:kGHUnitWaitStatusSuccess ];
  }];
  
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNil(result, @"shouldn't return data on error : %@",result);
  GHAssertNotNil(error, @"error: %@",[error localizedDescription]);
}

-(void) testValidateTokens
{
  [self prepare];

  //  OCCurrency* cdd = [[OCCurrency alloc] initWithAttributes:nil];
  
  NSArray* blanks = [NSArray arrayWithObjects: [[OCBlank alloc] initWithAttributes:nil],
                     [[OCBlank alloc] initWithAttributes:nil],
                     [[OCBlank alloc] initWithAttributes:nil],
                     nil];
  
  /*
   NSArray* blanks = [NSArray arrayWithObjects: [OCBlank blankWithCurrency:cdd
   WithDenomination:1
   WithMintKey:nil],
   [OCBlank blankWithCurrency:cdd
   WithDenomination:1
   WithMintKey:nil],
   
   nil];
   */
  static NSArray *result;
  static NSError *error;

  // test existing url
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.LOCAL_URL];
  [client validateBlanks:blanks
    WithMessageReference:23
withTransactionReference:42
   WithAuthorisationInfo:@"opencoin"
                 success:^(NSArray *_result, NSError *_error) {
                   result = _result;
                   error = _error;
                   [self notify:kGHUnitWaitStatusSuccess ];
                 }];
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNotNil(result, @"no result returned: %@",result);
  GHAssertNil(error, @"no error awaited but got: %@",[error localizedDescription]);
}

-(void) test_request_renewal {
  [self prepare];
  
  //  OCCurrency* cdd = [[OCCurrency alloc] initWithAttributes:nil];
  
  NSArray* coins = [NSArray arrayWithObjects: [[OCBlank alloc] initWithAttributes:nil],
                     [[OCBlank alloc] initWithAttributes:nil],
                     [[OCBlank alloc] initWithAttributes:nil],
                     nil];
  
  /*
   NSArray* blanks = [NSArray arrayWithObjects: [OCBlank blankWithCurrency:cdd
   WithDenomination:1
   WithMintKey:nil],
   [OCBlank blankWithCurrency:cdd
   WithDenomination:1
   WithMintKey:nil],
   
   nil];
   */
  static NSArray *result;
  static NSError *error;
  
  // test existing url
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.LOCAL_URL];
  [client        renewalCoins:coins
                   withBlinds: nil
         withMessageReference:23
    withTransactionReference:42
       withAuthorisationInfo:@"opencoin"
                                            success:^(NSArray *_result, NSError *_error)
                 {
                   result = _result;
                   error = _error;
                   [self notify:kGHUnitWaitStatusSuccess ];
                 }];
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNotNil(result, @"no result returned: %@",result);
  GHAssertNil(error, @"no error awaited but got: %@",[error localizedDescription]);
}



@end