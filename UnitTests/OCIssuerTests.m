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
@property(readonly) NSURL* JS_ISSUER_URL;
@property(readonly) NSURL* SCALA_ISSUER_URL;
@property(readonly) NSURL* INVALID_URL;


@end

@implementation OCIssuerTests

- (void)setUp
{
  [super setUp];
  _JS_ISSUER_URL      = [NSURL URLWithString:@"http://127.0.0.1:6789/" ];
  _SCALA_ISSUER_URL   = [NSURL URLWithString:@"https://mighty-lake-9219.herokuapp.com/gulden/" ];
  _INVALID_URL        = [NSURL URLWithString:@"https://mighty-lake-9219.herokuapp.com/nullar/" ];
  
  // Set-up code here.
}

-(void) doTestGetCddSerial:(NSURL*) baseURL
{
  [self prepare];
  
  static NSNumber *serial;
  static NSError *error;
  
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:baseURL];
  [client getCDDSerial: ^(NSNumber *_serial, NSError *_error) {
    
    serial = _serial;
    error = _error;
    
    [self notify:kGHUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNil( error,  @"no error awaited but got: %@",[error localizedDescription]);
  GHAssertNotNil(serial, @"no result returned: %@",serial);
}

-(void) testGetCddSerial_js_issuer
{
  [self doTestGetCddSerial:self.JS_ISSUER_URL];
}

-(void) testGetCddSerial_scala_issuer
{
  [self doTestGetCddSerial: self.SCALA_ISSUER_URL];
}

-(void) doTestGetCurrency:(NSURL*) baseURL withSerial:(NSNumber*) serial
{
  [self prepare];
  
  static OCCurrency *result;
  static NSError *error;
  
  // test existing cdd
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:baseURL];
  [client getCDD: serial
         success: ^(OCCurrency *_result, NSError *_error) {
           result = _result;
           error = _error;
           [self notify:kGHUnitWaitStatusSuccess ];
         }
   ];
  
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNotNil(result, @"no currencies returned: %@",result);
  GHAssertNil(error, @"no error awaited but got: %@",[error localizedDescription]);
}

-(void) testGetCurrencyWithValidSerial_js_issuer
{
  [self doTestGetCurrency:self.JS_ISSUER_URL
               withSerial:[NSNumber numberWithInt:1] ];
}

-(void) testGetCurrencyWithValidSerial_scala_issuer
{
  [self doTestGetCurrency:self.SCALA_ISSUER_URL
               withSerial:[NSNumber numberWithInt:1] ];
}

-(void) testGetCurrencyWithInvalidSerial_js_issuer
{
  [self doTestGetCurrency:self.JS_ISSUER_URL
               withSerial:[NSNumber numberWithInt:2] ];
}

-(void) testGetCurrencyWithInvalidSerial_scala_issuer
{
  [self doTestGetCurrency:self.SCALA_ISSUER_URL
               withSerial:[NSNumber numberWithInt:2] ];
}

-(void) testGetLatestCDD_js_issuer
{
  [self prepare];
  
  static OCCurrency *result;
  static NSError *error;
  
  // test existing cdd
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.JS_ISSUER_URL];
  [client getLatestCDD: ^(OCCurrency *_result, NSError *_error) {
           result = _result;
           error = _error;
           [self notify:kGHUnitWaitStatusSuccess ];
         }
   ];
  
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNotNil(result, @"no currencies returned: %@",result);
  GHAssertNil(error, @"no error awaited but got: %@",[error localizedDescription]);
}

-(void) testGetLatestCDD_scala_issuer
{
  [self prepare];
  
  static OCCurrency *result;
  static NSError *error;
  
  // test existing cdd
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.SCALA_ISSUER_URL];
  [client getLatestCDD: ^(OCCurrency *_result, NSError *_error) {
    result = _result;
    error = _error;
    [self notify:kGHUnitWaitStatusSuccess ];
  }
  ];
  
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNotNil(result, @"no currencies returned: %@",result);
  GHAssertNil(error, @"no error awaited but got: %@",[error localizedDescription]);
}

-(void) testGetLatestCDD_InvalidURL
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
  
  GHAssertNil(result, @"shouldn't return data on error : %@",result);
  GHAssertNotNil(error, @"error: %@",[error localizedDescription]);
}

-(void) doTestLoadMintKeys:(NSURL*) baseURL
{
  [self prepare];
  
  static NSArray *result;
  static NSError *error;
  
  // test existing url
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:baseURL];
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

-(void) testLoadMintKeys_from_js_issuer
{
  [self doTestLoadMintKeys:self.JS_ISSUER_URL];
}

-(void) testLoadMintKeys_from_scala_issuer
{
  [self doTestLoadMintKeys:self.SCALA_ISSUER_URL];
}

-(void) testLoadMintKeys_from_invalid_url
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
  
  [self waitForTimeout:10.0];
  
  GHAssertNil(result, @"shouldn't return data on error : %@",result);
  GHAssertNotNil(error, @"error: %@",[error localizedDescription]);
}

-(void) testValidateTokens_js_issuer
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
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.JS_ISSUER_URL];
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

-(void) test_request_renewal_js_issuer {
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
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.JS_ISSUER_URL];
  [client        renewalCoins:coins
         withMessageReference:23
    withTransactionReference:42
       withAuthorisationInfo:@"opencoin"
                                            success:^(NSArray *_blinds, NSError *_error)
                 {
                   result = _blinds;
                   error = _error;
                   [self notify:kGHUnitWaitStatusSuccess ];
                 }];
  [self waitForStatus:kGHUnitWaitStatusSuccess timeout:10.0];
  
  GHAssertNotNil(result, @"no result returned: %@",result);
  GHAssertEquals([coins count], [result count], @"coins and blinds should have the same count");
  GHAssertNil(error, @"no error awaited but got: %@",[error localizedDescription]);
}



@end