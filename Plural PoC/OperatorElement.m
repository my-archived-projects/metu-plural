//
//  OperatorElement.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/20/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#import "OperatorElement.h"

@interface OperatorElement()
@property (nonatomic, readwrite) NSString *elementText;
@end

@implementation OperatorElement

- (instancetype) initWithTitle:(NSString *)title frame:(CGRect)frame {
	if (CGRectEqualToRect(frame, CGRectZero)) {
		frame = CGRectMake(440, 15, 36, 36);
	}

	self = [super initWithFrame:frame];
	self.elementText = title;
	self.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
	self.layer.cornerRadius = 18;
	self.layer.masksToBounds = YES;
	self.layer.borderColor = [UIColor blackColor].CGColor;
	self.layer.borderWidth = 1.2;

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor blackColor];
	label.font = [UIFont boldSystemFontOfSize:13];
	label.text = self.elementText;
	label.numberOfLines = 0;
	label.lineBreakMode = NSLineBreakByWordWrapping;
	label.textAlignment = NSTextAlignmentCenter;
	[self addSubview:label];
	[self bringSubviewToFront:label];

	return self;
}

@end
