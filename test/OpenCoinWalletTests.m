//
//  OpenCoinWalletTests.m
//  OpenCoinWalletTests
//
//  Created by Gulliver on 16.11.12.
//  Copyright (c) 2012 Opencoin Team. All rights reserved.
//

#import "OpenCoinWalletTests.h"
#import "OCHTTPClient.h"

@interface OpenCoinWalletTests()

@property(readonly) NSURL* VALID_URL;
@property(readonly) NSURL* INVALID_URL;

@end

@implementation OpenCoinWalletTests

- (void)setUp
{
    [super setUp];
  _VALID_URL   = [NSURL URLWithString:@"https://mighty-lake-9219.herokuapp.com/gulden/" ];
  _INVALID_URL = [NSURL URLWithString:@"https://mighty-lake-9219.herokuapp.com/nullar/" ];
  
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void) testLoadCurrencies
{
  // test existing cdd
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.VALID_URL];
  [client getLatestCDD:^(OCCurrency *result, NSError *error) {
    STAssertNotNil(result, @"no currencies returned: %@",result);
    STAssertNil(error, @"no error awaited but got: %@",[error localizedDescription]);
   }
   ];
  
  // not existent cdd
  client = [OCHttpClient clientWithBaseURL:self.INVALID_URL];
  [client getLatestCDD:^(OCCurrency *result, NSError *error) {
    STAssertNil(result, @"shoudn't return data on error : %@",result);
    STAssertNotNil(error, @"error: %@",[error localizedDescription]);
  }
   ];
}

-(void) testLoadMintKeys
{
  // test existing url
  OCHttpClient* client = [OCHttpClient clientWithBaseURL:self.VALID_URL];
  [client getMintKeys:^(NSArray *result, NSError *error) {
    STAssertNotNil(result, @"no mint keys returned: %@",result);
    STAssertNil(error, @"no error awaited but got: %@",[error localizedDescription]);
  }
   ];
  
  // not existent url
  client = [OCHttpClient clientWithBaseURL:self.INVALID_URL];
  [client getMintKeys:^(NSArray *result, NSError *error) {
    STAssertNil(result, @"shoudn't return data on error : %@",result);
    STAssertNotNil(error, @"error: %@",[error localizedDescription]);
  }
   ];
}

- (void)xtestExample
{
      STFail(@"Unit tests are not implemented yet in OpenCoinWalletTests");
}



@end
