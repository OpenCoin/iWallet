//
//  OCCurrencyTableViewController.m
//  OpenCoinWallet
//
//  Created by Gulliver on 19.11.12.
//  Copyright (c) 2012 Opencoin Team. All rights reserved.
//

#import "OCCurrenciesTableViewController.h"
#import "OCCurrencyEditViewController.h"
#import "OCCurrency.h"

#import "OCHttpClient.h"
#import "AFJSONRequestOperation.h"

@interface OCCurrenciesTableViewController ()
@property(strong) NSMutableArray* currencies;
@end

NSDictionary * d;

@implementation OCCurrenciesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
      
        // Custom initialization
    }
    return self;
}

-(void) insertNewObject
{
  OCCurrency* c = [[OCCurrency alloc] initWithAttributes: nil];
  [self.currencies addObject:c];
  [self.tableView reloadData];
}

-(void) reload
{
  NSURL* baseURL = [NSURL URLWithString:@"https://mighty-lake-9219.herokuapp.com/gulden/" ];
  
  OCHttpClient* client = [[OCHttpClient alloc] initWithBaseURL:baseURL];
                          [client getLatestCDD:^(OCCurrency *result, NSError *error)
  {
    if(!error)
    {
      [self.currencies removeAllObjects];
      [self.currencies addObject:result];
      [self.tableView reloadData];
    }
    else
    {
      NSLog(@"error %@", [error localizedDescription]);
      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
    }
  }
  ];
}

- (void) viewDidAppear:(BOOL)animated
{
  [self reload];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.currencies = [NSMutableArray arrayWithObjects:/*@"EUR",@"Baachbucks",@"Love",*/ nil];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

  UIBarButtonItem *rButton = [[UIBarButtonItem alloc ]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                           target:self
                                                                           action:@selector(insertNewObject)];
  self.navigationItem.rightBarButtonItem = rButton;
  self.navigationItem.title = NSLocalizedString(@"Currencies",nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currencies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell...
  OCCurrency* c = (OCCurrency*)[self.currencies objectAtIndex:indexPath.row];
  cell.textLabel.text = [c currency_name];
  cell.detailTextLabel.text = [c cdd_location];
  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch(editingStyle)
  {
    case UITableViewCellEditingStyleDelete:  // Delete the row from the data source
      [self.currencies removeObjectAtIndex:indexPath.row];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case UITableViewCellEditingStyleInsert:
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    default:
      break;
    }
}

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
     OCCurrencyEditViewController *
    detailViewController = [[OCCurrencyEditViewController alloc]
                              initWithCurrency: [self.currencies objectAtIndex:indexPath.row]];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
