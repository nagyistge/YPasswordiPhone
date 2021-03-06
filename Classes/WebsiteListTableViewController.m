//
//  WebsiteListTableViewController.m
//
//  Created by Yann Esposito on 23/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebsiteListTableViewController.h"
#import "Website.h"


@implementation WebsiteListTableViewController
@synthesize managedObjectContext;
@synthesize websiteArray;


- (IBAction)add:(id)sender {
	managedObjectContext = [websiteListViewController managedObjectContext];
	
	Website *website=(Website *)[NSEntityDescription insertNewObjectForEntityForName:@"Website" inManagedObjectContext:managedObjectContext];
	website.url=@"new.com";
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
	
	[websiteArray insertObject:website atIndex:0];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						  withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

- (IBAction)edit:(UIBarButtonItem *)sender {
    [self.tableView setEditing:YES animated:YES];
    sender.title = NSLocalizedString(@"Done", @"Done");
    sender.style = UIBarButtonItemStyleDone;
    sender.target = self;
    sender.action = @selector(done:);
}

- (IBAction)done:(UIBarButtonItem *)sender {
    [self.tableView setEditing:NO animated:YES];
    sender.title = NSLocalizedString(@"Edit", @"Edit");
    sender.style = UIBarButtonItemStylePlain;
    sender.target = self;
    sender.action = @selector(edit:);
}

- (IBAction)cancel:(id)sender {
	[[websiteListViewController delegate] websiteListViewControllerDidFinish:websiteListViewController];
}

#pragma mark initialisation

- (void)viewDidLoad {
	managedObjectContext = [websiteListViewController managedObjectContext];

	// Create a request of Websites contained in the managedObjectContext
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Website" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	// sort the result by url name
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	// Execute the request
	NSError *error;
	NSMutableArray *mutableFetchResults=[[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// handle the error
	}
	[self setWebsiteArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
}

- (void)viewDidUnload {
	[websiteArray release];
	websiteArray=nil;
}

#pragma mark UITableViewDataSource
// required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self websiteArray] count];
}

// required
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    // Dequeue or create a new cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Website *curWebsite=[[self websiteArray] objectAtIndex:indexPath.row];
	cell.textLabel.text=[curWebsite url];
	cell.detailTextLabel.text=[curWebsite login];
	return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( editingStyle == UITableViewCellEditingStyleDelete ) {
		
		
		// Delete the managed object at the given index path.
		NSManagedObject *websiteToDelete = [websiteArray objectAtIndex:indexPath.row];
		[managedObjectContext deleteObject:websiteToDelete];
		
		// if the deleted website is the selected one, update the selected one to nil.
		if ( [[websiteListViewController delegate] website] == websiteToDelete ) {
			[[websiteListViewController delegate] setWebsite:nil];
		}

		// Commit the change
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// handle Error
			return;
		}
		
		// update the array and the tableView
		[websiteArray removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
	}
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Website *website = [websiteArray objectAtIndex:indexPath.row];
	[[websiteListViewController delegate] setWebsite:website];
	[[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"lastSelectedIndex"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[websiteListViewController delegate] websiteListViewControllerDidFinish:websiteListViewController];
}

@end
