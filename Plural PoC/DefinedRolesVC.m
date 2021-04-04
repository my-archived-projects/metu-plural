//
//  DefinedRolesVC.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/18/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#import "DefinedRolesVC.h"
#import "Operation.h"
#import "Role.h"

@interface DefinedRolesVC ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *definedRoles;

@property (nonatomic) NSArray *existingRoles;

- (IBAction) close:(id)sender;
@end

@implementation DefinedRolesVC

- (void) viewDidLoad {
	[super viewDidLoad];

	self.tableView.hidden = YES;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.definedRoles.hidden = YES;

	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:ROLE];
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	
	self.existingRoles = [ctx executeFetchRequest:req error:NULL];
	
	if (self.existingRoles && self.existingRoles.count > 0) {
		self.tableView.hidden = NO;
		
		[self.tableView reloadData];
	}
	else {
		self.definedRoles.text = @"No existing roles found";
	}
	self.definedRoles.hidden = NO;
}

- (IBAction) close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.existingRoles.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"RoleCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	}

	Role *role = self.existingRoles[indexPath.row];
	cell.imageView.image = ROLEIMG;
	cell.textLabel.text = role.name;

	NSMutableString *str = [[NSMutableString alloc] initWithString:@"Exists in Operations: "];
	for (Operation *o in role.operations) {
		[str appendString:o.name];
		[str appendString:@", "];
	}
	[str replaceCharactersInRange:NSMakeRange(str.length-2, 2) withString:@""];
	cell.detailTextLabel.text = str;

	return cell;
}

@end
