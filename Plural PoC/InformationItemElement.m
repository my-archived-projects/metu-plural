//
//  InformationItemElement.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/20/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#import "InformationItemElement.h"

@import QuartzCore;

@interface InformationItemElement()
@property (nonatomic, readwrite) UILabel *titleLabel;
@property (nonatomic, readwrite) NSString *elementText;
@end

@implementation InformationItemElement

- (instancetype) initWithTitle:(NSString *)title frame:(CGRect)frame {
	if (CGRectEqualToRect(frame, CGRectZero)) {
		frame = CGRectMake(358, 6, 90, 50);
	}
	
	self = [super initWithFrame:frame];
	self.elementText = title;
	
	UIBezierPath *aPath = [UIBezierPath bezierPath];
	[aPath moveToPoint:CGPointMake(0, 42)];
	
	[aPath addLineToPoint:CGPointMake(0, 0)];
	[aPath addLineToPoint:CGPointMake(90, 0)];
	[aPath addLineToPoint:CGPointMake(90, 42)];
	[aPath addCurveToPoint:CGPointMake(0, 42)
			 controlPoint1:CGPointMake(60, 22)
			 controlPoint2:CGPointMake(30, 62)];
	[aPath closePath];

	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	shapeLayer.path = aPath.CGPath;
	shapeLayer.strokeColor = [UIColor blackColor].CGColor;
	shapeLayer.fillColor = [UIColor colorWithRed:176.0/255 green:196.0/255 blue:222.0/255 alpha:1].CGColor;
	shapeLayer.lineWidth = 1.5;
	shapeLayer.position = CGPointMake(0, 0);
	[self.layer addSublayer:shapeLayer];
	
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.textColor = [UIColor blackColor];
	self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	self.titleLabel.text = self.elementText;
	self.titleLabel.numberOfLines = 0;
	self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:self.titleLabel];
	[self bringSubviewToFront:self.titleLabel];

	return self;
}

@end
