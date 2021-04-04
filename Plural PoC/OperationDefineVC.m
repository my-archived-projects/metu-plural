//
//  OperationDefineVC.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/19/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#import "OperationDefineVC.h"
#import "DefinedOperationsVC.h"
#import "Process.h"
#import "Operation.h"

@interface OperationDefineVC ()
@property (nonatomic, weak) IBOutlet UITextField *oNameTxt, *oDescTxt;
@property (nonatomic, weak) IBOutlet UILabel *definedProcesses;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *processes;

- (IBAction) addNewOperation:(id)sender;
- (IBAction) definedOperations:(id)sender;
- (IBAction) close:(id)sender;
@end

@implementation OperationDefineVC

- (void) viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.hidden = YES;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.definedProcesses.hidden = YES;
	
	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:PROCESS];
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

	self.processes = [ctx executeFetchRequest:req error:NULL];

	if (self.processes && self.processes.count > 0) {
		self.tableView.hidden = NO;

		[self.tableView reloadData];
	}
	else {
		self.definedProcesses.text = @"No existing processes found. Please create a process first!";
	}
	self.definedProcesses.hidden = NO;
}

- (IBAction) addNewOperation:(id)sender {

	NSString *oName = [self.oNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([oName isEqualToString:@""]) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																	   message:@"Role Name can not be blank!"
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Dismiss"
												  style:UIAlertActionStyleDefault
												handler:^(UIAlertAction * action) {
													[self.oNameTxt becomeFirstResponder];
												}]];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}
	[self.oNameTxt resignFirstResponder];
	[self.oDescTxt resignFirstResponder];
	
	NSArray *selectedCells = [self.tableView indexPathsForSelectedRows];
	if (selectedCells == nil) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																	   message:@"You need to select a Process from the list!"
																preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss"
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}
	
	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	Operation *operation = [NSEntityDescription insertNewObjectForEntityForName:OPERATION
														 inManagedObjectContext:ctx];
	operation.name = oName;
	operation.desc = [self.oDescTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSIndexPath *ip = selectedCells[0];
	Process *process = self.processes[ip.row];
	[process addOperationsObject:operation];

	operation.process = process;
	
	NSError *error = nil;
	UIAlertController* alert;

	if (![ctx save:&error]) {
		alert = [UIAlertController alertControllerWithTitle:@"Error"
													message:error.description
											 preferredStyle:UIAlertControllerStyleAlert];
	}
	else {
		alert = [UIAlertController alertControllerWithTitle:nil
													message:@"New Operation added successfully!"
											 preferredStyle:UIAlertControllerStyleAlert];
	}
	
	[alert addAction:[UIAlertAction actionWithTitle:@"Dismiss"
											  style:UIAlertActionStyleDefault
											handler:^(UIAlertAction * action) {
												self.oNameTxt.text = @"";
												self.oDescTxt.text = @"";
												[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
																			  animated:YES];
											}]];
	[self presentViewController:alert animated:YES completion:nil];
}

- (IBAction) definedOperations:(id)sender {
	DefinedOperationsVC *vc = [[DefinedOperationsVC alloc] initWithNibName:@"DefinedOperationsVC" bundle:nil];
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
	return self.processes.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"ProcessCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	}
	
	Process *process = self.processes[indexPath.row];
	cell.imageView.image = PROCESSIMG;
	cell.textLabel.text = process.name;
	cell.detailTextLabel.text = process.desc;
	
	return cell;
}

@end
