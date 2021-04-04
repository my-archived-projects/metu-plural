//
//  RoleDefineVC.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/18/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

@import CoreData;
#import "CoreDataContext.h"

#import "RoleDefineVC.h"
#import "DefinedRolesVC.h"
#import "Operation.h"
#import "Role.h"

@interface RoleDefineVC ()
@property (nonatomic, weak) IBOutlet UITextField *rNameTxt, *rDescTxt;
@property (nonatomic, weak) IBOutlet UILabel *definedOperations;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *operations;

- (IBAction) addNewRole:(id)sender;
- (IBAction) definedRoles:(id)sender;
- (IBAction) close:(id)sender;

- (void) reload;
@end

@implementation RoleDefineVC

- (void) viewDidLoad {
    [super viewDidLoad];

	[self reload];
}

- (void) reload {
	self.tableView.hidden = YES;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

	self.definedOperations.hidden = YES;

	NSArray *selecteds = [self.tableView indexPathsForSelectedRows];
	for (NSIndexPath *ip in selecteds) {
		[self.tableView deselectRowAtIndexPath:ip animated:YES];
	}
	
	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:OPERATION];
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	req.predicate = [NSPredicate predicateWithFormat:@"role = nil"];
	
	self.operations = [ctx executeFetchRequest:req error:NULL];
	
	if (self.operations && self.operations.count > 0) {
		self.tableView.hidden = NO;
		
		[self.tableView reloadData];
	}
	else {
		self.definedOperations.text = @"No existing or unassigned Operations found!";
	}
	self.definedOperations.hidden = NO;
}

- (IBAction) addNewRole:(id)sender {

	NSString *rName = [self.rNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([rName isEqualToString:@""]) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																	   message:@"Role Name can not be blank!"
																preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss"
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {
																  [self.rNameTxt becomeFirstResponder];
															  }];
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}
	[self.rNameTxt resignFirstResponder];
	[self.rDescTxt resignFirstResponder];

	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	Role *newRole = [NSEntityDescription insertNewObjectForEntityForName:ROLE
														inManagedObjectContext:ctx];
	newRole.name = rName;
	newRole.desc = [self.rDescTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	NSArray *selectedCells = [self.tableView indexPathsForSelectedRows];
	for (NSIndexPath *ip in selectedCells) {
		Operation *operation = self.operations[ip.row];
		operation.role = newRole;
		[newRole addOperationsObject:operation];
	}

	NSError *error = nil;
	UIAlertController* alert;
	if (![ctx save:&error]) {
		alert = [UIAlertController alertControllerWithTitle:@"Error"
													message:error.description
											 preferredStyle:UIAlertControllerStyleAlert];
	}
	else {
		alert = [UIAlertController alertControllerWithTitle:nil
													message:@"New Role added successfully!"
											 preferredStyle:UIAlertControllerStyleAlert];
	}

	[alert addAction:[UIAlertAction actionWithTitle:@"Dismiss"
											  style:UIAlertActionStyleDefault
											handler:^(UIAlertAction * action) {
												self.rNameTxt.text = @"";
												self.rDescTxt.text = @"";
												
												[self reload];
											}]];
	[self presentViewController:alert animated:YES completion:nil];
}

- (IBAction) definedRoles:(id)sender {
	DefinedRolesVC *vc = [[DefinedRolesVC alloc] initWithNibName:@"DefinedRolesVC" bundle:nil];
	vc.modalPresentationStyle = UIModalPresentationFormSheet;
	vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction) close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 76;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.operations.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"OperationCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	}

	Operation *operation = self.operations[indexPath.row];
	cell.imageView.image = OPERATIONIMG;
	cell.textLabel.text = operation.name;
	cell.detailTextLabel.text = operation.desc;

	return cell;
}

@end
