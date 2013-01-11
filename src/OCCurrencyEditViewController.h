//
//  OCCurrencyEditViewController.h
//  OpenCoinWallet
//
//  Created by Gulliver on 19.11.12.
//  Copyright (c) 2012 Opencoin Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCCurrency.h"

@interface OCCurrencyEditViewController : UITableViewController
-(id)initWithCurrency:(OCCurrency*)currency;
@end
