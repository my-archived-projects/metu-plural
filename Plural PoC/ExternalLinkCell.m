//
//  ExternalLinkCell.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 5/10/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#import "ExternalLinkCell.h"

#import "RoleElement.h"
#import "InformationItemElement.h"

@implementation ExternalLinkCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

	self.backgroundView = nil;
	self.contentView.backgroundColor = [UIColor whiteColor];
	self.accessoryType = UITableViewCellAccessoryNone;

	self.roleElemView = [[RoleElement alloc] initWithTitle:@"Role" frame:CGRectMake(10, 10, 90, 50)];
	[self.contentView addSubview:self.roleElemView];

	self.iieElemView = [[InformationItemElement	alloc] initWithTitle:@"Element" frame:CGRectMake(110, 10, 90, 50)];
	[self.contentView addSubview:self.iieElemView];

	UILabel *descLbl = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 248, 20)];
	descLbl.text = @"Enter the connecting activity text";
	descLbl.font = [UIFont systemFontOfSize:13];
	descLbl.backgroundColor = [UIColor clearColor];
	descLbl.textAlignment = NSTextAlignmentCenter;
	[self.contentView addSubview:descLbl];

	self.activityText = [[UITextField alloc] initWithFrame:CGRectMake(210, 32, 248, 26)];
	self.activityText.borderStyle = UITextBorderStyleRoundedRect;
	[self.contentView addSubview:self.activityText];
	
	self.horizontal = [[UISegmentedControl alloc] initWithItems:@[@"LEFT",@"RIGHT"]];
	self.horizontal.selectedSegmentIndex = UISegmentedControlNoSegment;
	self.horizontal.center = CGPointMake(520, 35);
	[self.contentView addSubview:self.horizontal];

	self.vertical = [[UISegmentedControl alloc] initWithItems:@[@"TOP",@"MIDDLE",@"BOTTOM"]];
	self.vertical.selectedSegmentIndex = UISegmentedControlNoSegment;
	self.vertical.center = CGPointMake(688, 35);
	[self.contentView addSubview:self.vertical];
	
	self.decision = [[UISegmentedControl alloc] initWithItems:@[@"ACCEPT",@"REJECT"]];
	self.decision.selectedSegmentIndex = 0;
	self.decision.center = CGPointMake(870, 35);
	[self.contentView addSubview:self.decision];

	return self;
}

@end
