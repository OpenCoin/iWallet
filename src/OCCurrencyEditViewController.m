//
//  OCCurrencyEditViewController.m
//  OpenCoinWallet
//
//  Created by Gulliver on 19.11.12.
//  Copyright (c) 2012 Opencoin Team. All rights reserved.
//

#import "OCCurrencyEditViewController.h"
#import "OCPublicKey.h"

@interface OCCurrencyEditViewController ()
@property (retain) OCCurrency* currency;
@end

@implementation OCCurrencyEditViewController

- (id)initWithCurrency:(OCCurrency *)currency
{
  self = [self initWithStyle:UITableViewStyleGrouped];

  _currency = currency;
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 16;
}

#define FILL_CELL(index,name)   case index: \
                                  cell.textLabel.text = @#name; \
                                  cell.detailTextLabel.text = [_currency name]; \
                                  break;

#define FILL_CELL_INT(index,name)   case index: \
cell.textLabel.text = @#name; \
cell.detailTextLabel.text = [[NSNumber numberWithInteger:[_currency name]] description]; \
break;

#define FILL_CELL_DESC(index,name)   case index: \
cell.textLabel.text = @#name; \
cell.detailTextLabel.text = [[_currency name] description]; \
break;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier];
  }
  
  switch (indexPath.row)
  {
      FILL_CELL(0, currency_name)
      FILL_CELL(1,additional_info)
      FILL_CELL_DESC(2,cdd_expiry_date)
      FILL_CELL_DESC(3,cdd_location)
      FILL_CELL_INT(4,cdd_serial)
      FILL_CELL_DESC(5,cdd_signing_date)
      FILL_CELL_INT(6,currency_divisor)
      FILL_CELL(7,currency_name)
      FILL_CELL_DESC(8,denominations)
      
      FILL_CELL_DESC(9,info_service)
      
      FILL_CELL_DESC(10,invalidation_service)
      FILL_CELL(11,issuer_cipher_suite)
      FILL_CELL_DESC(12,issuer_public_master_key)
      FILL_CELL_DESC(13,protocol_version)
      FILL_CELL_DESC(14,renewal_service)
      FILL_CELL_DESC(15,validation_service)
      
    default:
      break;
  }
  
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
