//
//  RoleElement.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/20/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#import "RoleElement.h"

@import QuartzCore;

@interface RoleElement()
@property (nonatomic, readwrite) UILabel *titleLabel;
@property (nonatomic, readwrite) NSString *elementText;
@end

@implementation RoleElement

- (instancetype) initWithTitle:(NSString *)title frame:(CGRect)frame {
	if (CGRectEqualToRect(frame, CGRectZero)) {
		frame = CGRectMake(146, 6, 90, 50);
	}

	self = [super initWithFrame:frame];
	self.elementText = title;
	self.backgroundColor = [UIColor colorWithRed:255.0/255 green:250.0/255 blue:205.0/255 alpha:1];
	self.layer.borderColor = [UIColor blackColor].CGColor;
	self.layer.borderWidth = 1.5;

	UIView *line = [[UIView alloc] initWithFrame:CGRectMake(4, 0, 1.5, frame.size.height)];
	line.backgroundColor = [UIColor blackColor];
	[self addSubview:line];

	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 3, frame.size.width-10.0, frame.size.height-6.0)];
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.textColor = [UIColor blackColor];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
	self.titleLabel.text = self.elementText;
	self.titleLabel.numberOfLines = 0;
	self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:self.titleLabel];
	[self bringSubviewToFront:self.titleLabel];

	return self;
}

@end
