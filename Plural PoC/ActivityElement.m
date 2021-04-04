//
//  ActivityElement.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/20/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#import "ActivityElement.h"

@import QuartzCore;

@interface ActivityElement()
@property (nonatomic, readwrite) NSString *elementText;
@end

@implementation ActivityElement

- (instancetype) initWithTitle:(NSString *)title frame:(CGRect)frame {
	
	if (CGRectEqualToRect(frame, CGRectZero)) {
		frame = CGRectMake(40, 6, 90, 50);
	}

	self = [super initWithFrame:frame];
	self.elementText = title;
	self.backgroundColor = [UIColor colorWithRed:152.0/255 green:251.0/255 blue:152.0/255 alpha:1];
	self.layer.cornerRadius = 16;
	self.layer.masksToBounds = YES;
	self.layer.borderColor = [UIColor blackColor].CGColor;
	self.layer.borderWidth = 1.2;

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 3, 82, 44)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor blackColor];
	label.font = [UIFont boldSystemFontOfSize:12];
	label.text = self.elementText;
	label.numberOfLines = 0;
	label.lineBreakMode = NSLineBreakByWordWrapping;
	label.textAlignment = NSTextAlignmentCenter;
	[self addSubview:label];
	[self bringSubviewToFront:label];
	
	return self;
}

@end
