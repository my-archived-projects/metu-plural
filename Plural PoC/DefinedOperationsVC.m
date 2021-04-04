//
//  DefinedOperationsVC.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/19/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#import "DefinedOperationsVC.h"
#import "Operation.h"
#import "Process.h"

@interface DefinedOperationsVC ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *definedOperations;

@property (nonatomic) NSArray *existingOperations;

- (IBAction) close:(id)sender;
@end

@implementation DefinedOperationsVC

- (void) viewDidLoad {
    [super viewDidLoad];

	self.tableView.hidden = YES;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.definedOperations.hidden = YES;

	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:OPERATION];
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	
	self.existingOperations = [ctx executeFetchRequest:req error:NULL];
	
	if (self.existingOperations && self.existingOperations.count > 0) {
		self.tableView.hidden = NO;
		
		[self.tableView reloadData];
	}
	else {
		self.definedOperations.text = @"No existing Operations found";
	}
	self.definedOperations.hidden = NO;
}

- (IBAction) close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 84;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.existingOperations.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"OperationCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	}
	
	Operation *operation = self.existingOperations[indexPath.row];
	cell.imageView.image = OPERATIONIMG;
	cell.textLabel.text = operation.name;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Belongs to Process: %@", operation.process.name];
	
	return cell;
}



@end
