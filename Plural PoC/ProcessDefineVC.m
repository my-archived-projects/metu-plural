//
//  ProcessDefineVC.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/17/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

@import CoreData;
#import "CoreDataContext.h"

#import "ProcessDefineVC.h"
#import "Process.h"

@interface ProcessDefineVC ()
@property (nonatomic, weak) IBOutlet UITextField *pNameTxt, *pDescTxt;
@property (nonatomic, weak) IBOutlet UILabel *definedProcesses;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *existingProcesses;

- (IBAction) addNewProcess:(id)sender;
- (IBAction) close:(id)sender;

- (void) reload;
@end

@implementation ProcessDefineVC

- (void) viewDidLoad {
	[super viewDidLoad];

	self.tableView.hidden = YES;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.definedProcesses.hidden = YES;

	[self reload];
}

- (void) reload {
	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:PROCESS];
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	
	self.existingProcesses = [ctx executeFetchRequest:req error:NULL];
	
	if (self.existingProcesses && self.existingProcesses.count > 0) {
		self.tableView.hidden = NO;

		[self.tableView reloadData];
	}
	else {
		self.definedProcesses.text = @"No existing process found";
	}
	self.definedProcesses.hidden = NO;
}

- (IBAction) addNewProcess:(id)sender {
	NSString *pName = [self.pNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([pName isEqualToString:@""]) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																	   message:@"Process Name can not be blank!"
																preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss"
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {
																  [self.pNameTxt becomeFirstResponder];
															  }];
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}
	
	[self.pNameTxt resignFirstResponder];
	[self.pDescTxt resignFirstResponder];

	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	Process *newProcess = [NSEntityDescription insertNewObjectForEntityForName:PROCESS
														inManagedObjectContext:ctx];
	newProcess.name = pName;
	newProcess.desc = [self.pDescTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	[ctx save:NULL];

	UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
																   message:@"New Process added successfully!"
															preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss"
															style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction * action) {
															  self.pNameTxt.text = @"";
															  self.pDescTxt.text = @"";
															  self.definedProcesses.text = @"Defined Processes";

															  [self reload];
														  }];
	[alert addAction:defaultAction];
	[self presentViewController:alert animated:YES completion:nil];
}

- (IBAction) close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 76;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.existingProcesses.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"ProcessCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	}

	Process *process = self.existingProcesses[indexPath.row];
	cell.imageView.image = PROCESSIMG;
	cell.textLabel.text = process.name;
	cell.detailTextLabel.text = process.desc;

	return cell;
}

@end
