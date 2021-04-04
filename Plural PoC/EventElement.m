//
//  EventElement.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/20/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#import "EventElement.h"

@import QuartzCore;

@interface EventElement()
@property (nonatomic, readwrite) NSString *elementText;
@end

@implementation EventElement

- (instancetype) initWithTitle:(NSString *)title frame:(CGRect)frame {

	if (CGRectEqualToRect(frame, CGRectZero)) {
		frame = CGRectMake(252, 6, 90, 50);
	}

	self = [super initWithFrame:frame];
	self.elementText = title;

	UIBezierPath *aPath = [UIBezierPath bezierPath];
 	[aPath moveToPoint:CGPointMake(8, 0)];

	[aPath addLineToPoint:CGPointMake(82, 0)];
	[aPath addLineToPoint:CGPointMake(90, 25)];
	[aPath addLineToPoint:CGPointMake(82, 50)];
	[aPath addLineToPoint:CGPointMake(8, 50)];
	[aPath addLineToPoint:CGPointMake(0, 25)];
	[aPath addLineToPoint:CGPointMake(8, 0)];
	[aPath closePath];

	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.path = aPath.CGPath;
	shapeLayer.strokeColor = [UIColor blackColor].CGColor;
	shapeLayer.fillColor = [UIColor colorWithRed:238.0/255 green:130.0/255 blue:238.0/255 alpha:1].CGColor;
	shapeLayer.lineWidth = 1.5;
	shapeLayer.position = CGPointMake(0, 0);
	[self.layer addSublayer:shapeLayer];

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 74, 50)];
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
