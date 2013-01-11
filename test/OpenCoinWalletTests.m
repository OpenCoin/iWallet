//
//  OpenCoinWalletTests.m
//  OpenCoinWalletTests
//
//  Created by Gulliver on 16.11.12.
//  Copyright (c) 2012 Opencoin Team. All rights reserved.
//

#import "OpenCoinWalletTests.h"
#import "AFHTTPClient.h"

@implementation OpenCoinWalletTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

-(void) testLoadCurrencies
{
  NSURL* baseURL = [NSURL URLWithString:@"https://mighty-lake-9219.herokuapp.com/gulden/" ];
  AFHTTPClient* client = [AFHTTPClient clientWithBaseURL:baseURL];
  [client getPath:@"cdds/latest"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
          }
   
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            STFail(@"error");
            
          }];
}

- (void)testExample
{
      STFail(@"Unit tests are not implemented yet in OpenCoinWalletTests");
}



@end
