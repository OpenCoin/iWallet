//
//  OCWalletItemsViewController.m
//  OpenCoinWallet
//
//  Created by Gulliver on 19.11.12.
//  Copyright (c) 2012 Opencoin Team. All rights reserved.
//

#import "OCWalletItemsViewController.h"
#import "OCPayViewController.h"
#import "OCMintKeysViewController.h"

@interface OCWalletItemsViewController ()
@property(strong) NSDictionary* buttons;
@property(strong) NSDictionary* section2;
@end

@implementation OCWalletItemsViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.buttons = [NSDictionary
                  dictionaryWithObjects:
                  [NSArray arrayWithObjects:
                   [OCPayViewController class],
                   [OCPayViewController class],
                   [OCPayViewController class],
                   [OCPayViewController class],
                   [OCPayViewController class],
                   nil
                   ]
                  forKeys:[NSArray arrayWithObjects:
                           NSLocalizedString(@"Pay"        ,nil),
                           NSLocalizedString(@"Receive"    ,nil),
                           NSLocalizedString(@"Get change" ,nil),
                           NSLocalizedString(@"Withdraw"   ,nil),
                           NSLocalizedString(@"Redeem"     ,nil),
                           nil]
                  ];

  self.section2 = [NSDictionary
                  dictionaryWithObjects:
                  [NSArray arrayWithObjects:
                   [ OCMintKeysViewController class],
                     nil
                   ]
                  forKeys:[NSArray arrayWithObjects:
                           NSLocalizedString(@"Mintkeys"        ,nil),
                           nil]
                  ];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  switch(section)
  {
    case 0:
      return self.buttons.count;

    case 1:
      return self.section2.count;
    default:
      return 1;
  }
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
  switch(indexPath.section)
    {
      case 0:
        cell.textLabel.text = [[self.buttons allKeys] objectAtIndex:indexPath.row];
        break;
      
      case 1:
        cell.textLabel.text = NSLocalizedString(@"Advanced", nil);
        break;
        
      default:
        ;
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
  UIViewController *detailViewController;
  
  switch(indexPath.section)
  {
    case 0:
    {
      Class c = [[self.buttons allValues] objectAtIndex:indexPath.row];
      detailViewController =[[c alloc] init];
    }
    break;
    
    case 1:
    {
      Class c = [[self.section2 allValues] objectAtIndex:indexPath.row];
      detailViewController =[[c alloc] init];
    }
    break;
      
    default:
      detailViewController = nil;
  }
  
  // Pass the selected object to the new view controller.
  if (detailViewController)
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
