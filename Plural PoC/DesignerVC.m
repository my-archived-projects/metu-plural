//
//  DesignerVC.m
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/19/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

#import "DesignerVC.h"

#import "ActivityElement.h"
#import "RoleElement.h"
#import "EventElement.h"
#import "InformationItemElement.h"
#import "OperatorElement.h"

#import "Operation.h"
#import "Role.h"
#import "Element.h"

#import "ExternalLinkCell.h"

#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

PluralElementType getElementType (id<PluralElement> element) {
	if ([element isKindOfClass:[ActivityElement class]]) {
		return PluralActivityElement;
	}
	else if ([element isKindOfClass:[RoleElement class]]) {
		return PluralRoleElement;
	}
	else if ([element isKindOfClass:[EventElement class]]) {
		return PluralEventElement;
	}
	else if ([element isKindOfClass:[InformationItemElement class]]) {
		return PluralInformationItemElement;
	}
	else if ([element isKindOfClass:[OperatorElement class]]) {
		return PluralOperatorElement;
	}
	return -1;
};

CGPoint getLinkPoint (CGRect frame, LinkSide side) {
	if (side == TOP) {
		return CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y);
	}
	if (side == BOTTOM) {
		return CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height);
	}
	if (side == LEFT) {
		return CGPointMake(frame.origin.x, frame.origin.y + frame.size.height / 2);
	}
	if (side == RIGHT) {
		return CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height / 2);
	}
	
	return CGPointMake(0, 0);
}

NSArray* getLinkSides (UIView *startElement, UIView *endElement) {

	CGRect frame1 = startElement.frame, frame2 = endElement.frame;
	LinkSide start, end;

	// Up - Down
	if (frame1.origin.y + frame1.size.height < frame2.origin.y) {
		end = TOP;
		
		if ([startElement isKindOfClass:[OperatorElement class]]) {
			if (frame1.origin.x + frame1.size.width < frame2.origin.x) {
				start = RIGHT;
			}
			else if (frame2.origin.x + frame2.size.width < frame1.origin.x) {
				start = LEFT;
			}
			else {
				start = BOTTOM;
			}
		}
		// else if ([endElement isKindOfClass:[OperatorElement class]]) {
		else {
			start = BOTTOM;

			if ((frame2.origin.y - frame1.origin.y) > 60) {
				CGPoint leftLinkPoint = getLinkPoint(frame2, LEFT);
				CGPoint rightLinkPoint = getLinkPoint(frame2, RIGHT);
				CGPoint startPoint = getLinkPoint(frame1, BOTTOM);
				
				if (startPoint.x < leftLinkPoint.x && (startPoint.x - leftLinkPoint.x < 25)) {
					end = LEFT;
				}
				else if (startPoint.x > rightLinkPoint.x && (startPoint.x - rightLinkPoint.x < 25)) {
					end = RIGHT;
				}
				else {
					end = TOP;
				}
			}
			else {
				end = TOP;
			}
		}
	}
	else if (frame1.origin.y - 20 > frame2.origin.y + frame2.size.height) {
		end = BOTTOM;
		
		if ([startElement isKindOfClass:[OperatorElement class]]) {
			if (frame1.origin.x + frame1.size.width < frame2.origin.x) {
				start = RIGHT;
			}
			else if (frame2.origin.x + frame2.size.width < frame1.origin.x) {
				start = LEFT;
			}
			else {
				start = TOP;
			}
		}
		else {
			start = TOP;
		}
	}
	else if (frame1.origin.x < frame2.origin.x) {
		start = RIGHT;
		end = (getLinkPoint(frame1, start).y < frame2.origin.y - 10) ? TOP : LEFT;
	}
	else if (frame1.origin.x > frame2.origin.x) {
		start = LEFT;
		end = (getLinkPoint(frame1, start).y < frame2.origin.y - 10) ? TOP : RIGHT;
	}

	return @[@(start), @(end)];
}

NSArray* getCornerPoint(int cornerCount, LinkSide startSide, CGPoint startPoint, LinkSide endSide, CGPoint endPoint) {
	if (cornerCount == 1) {
		if (startSide == LEFT || startSide == RIGHT) {
			return @[NSStringFromCGPoint(CGPointMake(endPoint.x, startPoint.y))];
		}
		else if (startSide == TOP || startSide == BOTTOM) {
			return @[NSStringFromCGPoint(CGPointMake(startPoint.x, endPoint.y))];
		}
	}
	if (cornerCount == 2) {
		if (startSide == RIGHT) {
			return @[NSStringFromCGPoint(CGPointMake(startPoint.x + 10, startPoint.y)),
					 NSStringFromCGPoint(CGPointMake(startPoint.x + 10, endPoint.y))];
		}
		else if (startSide == LEFT) {
			return @[NSStringFromCGPoint(CGPointMake(startPoint.x - 10, startPoint.y)),
					 NSStringFromCGPoint(CGPointMake(startPoint.x - 10, endPoint.y))];
		}
		else if (startSide == TOP) {
			return @[NSStringFromCGPoint(CGPointMake(startPoint.x, startPoint.y - 10)),
					 NSStringFromCGPoint(CGPointMake(endPoint.x, startPoint.y - 10))];
		}
		else if (startSide == BOTTOM) {
			return @[NSStringFromCGPoint(CGPointMake(startPoint.x, startPoint.y + 10)),
					 NSStringFromCGPoint(CGPointMake(endPoint.x, startPoint.y + 10))];
		}
	}
	
	return nil;
}

int getCornerCount(LinkSide startLinkSide, LinkSide endLinkSide, UIView *startElement, UIView *endElement) {
	CGRect frame1 = startElement.frame, frame2 = endElement.frame;
	
	if ((startLinkSide == RIGHT && endLinkSide == LEFT) || (startLinkSide == LEFT && endLinkSide == RIGHT)) {
		return (getLinkPoint(frame1, startLinkSide).y == getLinkPoint(frame2, endLinkSide).y) ? 0 : 2;
	}
	else if ((startLinkSide == TOP || startLinkSide == BOTTOM) && (endLinkSide == LEFT || endLinkSide == RIGHT)) {
		return 1;
	}
	else if ((startLinkSide == RIGHT || startLinkSide == LEFT) && (endLinkSide == TOP || endLinkSide == BOTTOM)) {
		return 1;
	}
	else if ((startLinkSide == TOP || startLinkSide == BOTTOM) && (endLinkSide == TOP || endLinkSide == BOTTOM)) {
		return (getLinkPoint(frame1, startLinkSide).x == getLinkPoint(frame2, endLinkSide).x) ? 0 : 2;
	}
	
	return 0;
}

NSArray* getArrowPoints(LinkSide endLinkside, CGPoint endPoint) {
	
	if (endLinkside == TOP) {
		return @[NSStringFromCGPoint(CGPointMake(endPoint.x-3, endPoint.y-5)),
				 NSStringFromCGPoint(CGPointMake(endPoint.x+3, endPoint.y-5))];
	}
	if (endLinkside == BOTTOM) {
		return @[NSStringFromCGPoint(CGPointMake(endPoint.x-3, endPoint.y+5)),
				 NSStringFromCGPoint(CGPointMake(endPoint.x+3, endPoint.y+5))];
	}
	if (endLinkside == LEFT) {
		return @[NSStringFromCGPoint(CGPointMake(endPoint.x-5, endPoint.y-3)),
				 NSStringFromCGPoint(CGPointMake(endPoint.x-5, endPoint.y+3))];
	}
	if (endLinkside == RIGHT) {
		return @[NSStringFromCGPoint(CGPointMake(endPoint.x+5, endPoint.y-3)),
				 NSStringFromCGPoint(CGPointMake(endPoint.x+5, endPoint.y+3))];
	}

	return nil;
}

@import QuartzCore;

@interface DesignerVC () <UITableViewDataSource, UITableViewDelegate> {
	CAShapeLayer *lineLayer;
	CGPoint startPoint;
	BOOL drawing;
}

@property (nonatomic, weak) IBOutlet UIView *elementsLibrary;
@property (nonatomic, weak) IBOutlet UIView *topView, *leftInteracts, *mainView, *rightInteracts;
@property (nonatomic, weak) IBOutlet UISwitch *lineSwitch;
@property (nonatomic) UIPopoverController *externalsPopover;
@property (nonatomic) NSMutableArray *elements, *externals;
@property (nonatomic) NSMutableDictionary *intLinkLayers, *extLinkLayers, *incLinkLayers;
@property (nonatomic) NSMutableDictionary *dictElementView, *dictViewElement, *dictExternals;
@property (nonatomic) NSArray *libraryElements;
@property (nonatomic) UIView *tmpElement, *linkStartElement;

- (void) initialize;
- (void) addOperationElements;
- (void) addIncomingElements;

- (IBAction) close:(id)sender;
- (IBAction) save:(id)sender;
- (IBAction) switchChanged;

- (CAShapeLayer *) createNewLayerWithPath:(UIBezierPath *)path;
- (UIBezierPath *) pathFrom:(UIView *)startElement to:(UIView *)endElement;
- (UIView *) getElementFrom:(NSArray *)views on:(CGPoint)point;
- (void) createExternalLinkToPosition:(CGPoint)position;
- (void) drawExternalRole:(Role *)role element:(Element *)element acText:(NSString *)text h:(long)h v:(long)v ex:(BOOL)flag;

- (void) endDrawing;
- (void) showTemporaryAlert:(NSString *)message;

@end

@implementation DesignerVC

- (void) viewDidLoad {
	[super viewDidLoad];

    [self initialize];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:YES];

	[self addOperationElements];
	[self addIncomingElements];
}

- (void) initialize {
	[[UIApplication sharedApplication] setStatusBarHidden:YES
											withAnimation:UIStatusBarAnimationSlide];

	self.elements = [NSMutableArray new];
	self.dictElementView = [NSMutableDictionary dictionary];
	self.dictViewElement = [NSMutableDictionary dictionary];
	self.dictExternals = [NSMutableDictionary dictionary];
	self.intLinkLayers = [NSMutableDictionary new];
	self.extLinkLayers = [NSMutableDictionary new];
	self.incLinkLayers = [NSMutableDictionary new];
	
	drawing = NO;
	
	ActivityElement *ae = [[ActivityElement alloc] initWithTitle:@"Activity" frame:CGRectZero];
	[self.elementsLibrary addSubview:ae];
	
	RoleElement *re = [[RoleElement alloc] initWithTitle:@"Role" frame:CGRectZero];
	[self.elementsLibrary addSubview:re];
	
	EventElement *ee = [[EventElement alloc] initWithTitle:@"Event" frame:CGRectZero];
	[self.elementsLibrary addSubview:ee];
	
	InformationItemElement *iie = [[InformationItemElement alloc] initWithTitle:@"Information Item" frame:CGRectZero];
	[self.elementsLibrary addSubview:iie];
	
	OperatorElement *andElement = [[OperatorElement alloc] initWithTitle:@"AND" frame:CGRectMake(464, 14, 36, 36)];
	[self.elementsLibrary addSubview:andElement];
	
	OperatorElement *orElement = [[OperatorElement alloc] initWithTitle:@"OR" frame:CGRectMake(516, 14, 36, 36)];
	[self.elementsLibrary addSubview:orElement];
	
	OperatorElement *xorElement = [[OperatorElement alloc] initWithTitle:@"XOR" frame:CGRectMake(568, 14, 36, 36)];
	[self.elementsLibrary addSubview:xorElement];
	
	self.libraryElements = @[ae, re, ee, iie, andElement, orElement, xorElement];
	
	RoleElement *topRole = [[RoleElement alloc] initWithTitle:self.operation.role.name
														frame:CGRectMake(455, 2, 120, 60)];
	topRole.titleLabel.font = [UIFont boldSystemFontOfSize:20];
	[self.topView addSubview:topRole];
	[self.topView bringSubviewToFront:topRole];
	
	CGFloat width = [self.operation.name sizeWithAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}].width;
	UILabel *opLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, width+16, 32)];
	opLabel.text = self.operation.name;
	opLabel.font = [UIFont boldSystemFontOfSize:18];
	opLabel.textAlignment = NSTextAlignmentCenter;
	opLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
	opLabel.layer.borderWidth = 1.5;
	opLabel.layer.borderColor = [UIColor blackColor].CGColor;
	[self.topView addSubview:opLabel];
	[self.topView bringSubviewToFront:opLabel];
	
	UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Designer_bg.png"]];
	bgView.center = self.mainView.center;
	bgView.contentMode = UIViewContentModeScaleAspectFill;
	[self.view addSubview:bgView];
	[self.view sendSubviewToBack:bgView];
}

- (void) addOperationElements {

	if (self.operation.elements && self.operation.elements.count > 0) {

		for (Element *element in self.operation.elements) {
			UIView *newElement = nil;

			if (element.type.integerValue == PluralActivityElement) {
				newElement = [[ActivityElement alloc] initWithTitle:element.name
															  frame:CGRectFromString(element.frame)];
			}
			else if (element.type.integerValue == PluralRoleElement) {
				newElement = [[RoleElement alloc] initWithTitle:element.name
														  frame:CGRectFromString(element.frame)];
			}
			else if (element.type.integerValue == PluralEventElement) {
				newElement = [[EventElement alloc] initWithTitle:element.name
														   frame:CGRectFromString(element.frame)];
			}
			else if (element.type.integerValue == PluralInformationItemElement) {
				newElement = [[InformationItemElement alloc] initWithTitle:element.name
																	 frame:CGRectFromString(element.frame)];
			}
			else if (element.type.integerValue == PluralOperatorElement) {
				newElement = [[OperatorElement alloc] initWithTitle:element.name
															  frame:CGRectFromString(element.frame)];
			}

			if (self.mainView.frame.size.width < (newElement.frame.origin.x + newElement.frame.size.width)) {
				continue;
			}

            if (newElement) {
                [self.elements addObject:newElement];
                [self.mainView addSubview:newElement];
                [self.mainView bringSubviewToFront:newElement];
                self.dictElementView[@[element]] = newElement;
                self.dictViewElement[@[newElement]] = element;
            }
		}

		for (Element *element in self.operation.elements) {
			if (element.outLinks && element.outLinks.count > 0) {
				for (Element *e in element.outLinks) {

					UIView *startElement = self.dictElementView[@[element]];
					UIView *endElement = self.dictElementView[@[e]];

					self.linkStartElement = startElement;
					UIBezierPath *path = [self pathFrom:self.linkStartElement to:endElement];

					CAShapeLayer *newLineLayer = [self createNewLayerWithPath:path];
					[self.mainView.layer addSublayer:newLineLayer];
					self.intLinkLayers[@[startElement, endElement]] = newLineLayer;
				}
			}
		}

		for (Element *element in self.operation.elements) {
			if (element.externalLinkTo) {
				Role *role = element.externalLinkTo;
				
				CGRect roleFrame = CGRectFromString([[NSUserDefaults standardUserDefaults] objectForKey:concat(element.name, role.name)]);

				RoleElement *roleElement = [[RoleElement alloc] initWithTitle:role.name frame:roleFrame];
				[self.view addSubview:roleElement];
				[self.view bringSubviewToFront:roleElement];

				UIView *startElement = self.dictElementView[@[element]];

				CGRect relFrame = startElement.frame;
				CGRect rect = CGRectMake(relFrame.origin.x + 158, relFrame.origin.y + 147,
										 relFrame.size.width, relFrame.size.height);
				UIView *mockStartView = [[UIView alloc] initWithFrame:rect];
				
				UIBezierPath *path = [self pathFrom:mockStartView to:roleElement];

				CAShapeLayer *newlineLayer = [self createNewLayerWithPath:path];
				[self.view.layer addSublayer:newlineLayer];
				self.extLinkLayers[@[startElement, roleElement, role]] = newlineLayer;

				NSString *externalName = concat(self.operation.role.name, element.name);
				NSArray *rejecteds = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALS_REJECTED];

				if (rejecteds && [rejecteds indexOfObject:externalName] != NSNotFound) {
					newlineLayer.strokeColor = [UIColor redColor].CGColor;
				}
			}
		}
	}
}

- (void) addIncomingElements {

	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:ELEMENT];
	NSArray *allElements = [ctx executeFetchRequest:req error:NULL];

	self.externals = [NSMutableArray array];
	NSMutableArray *alreadyAdded = [NSMutableArray array];

	NSArray *addeds = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALS];
	NSArray *rejecteds = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALS_REJECTED];

	for (Element *element in allElements) {
		if (element.externalLinkTo && element.externalLinkTo == self.operation.role) {
			NSString *externalName = concat(element.operation.role.name, element.name);

			// Check if rejected
			if (rejecteds && [rejecteds indexOfObject:externalName] != NSNotFound) {
				continue;
			}
			// Check if already added
			if (addeds && [addeds indexOfObject:externalName] != NSNotFound) {
				[alreadyAdded addObject:@[element.operation.role, element]];
			}
			else {
				[self.externals addObject:@[element.operation.role, element]];
			}
		}
	}

	if (alreadyAdded.count > 0) {
		NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALS_DATA];

		for (NSArray *array in alreadyAdded) {
			Role *role = array[0];
			Element *element = array[1];
			
			NSArray *array = [dict objectForKey:concat(role.name, element.name)];
			NSString *text = array[0];
			long h = ((NSNumber*)array[1]).longValue;
			long v = ((NSNumber*)array[2]).longValue;

			[self drawExternalRole:role element:element acText:text h:h v:v ex:YES];
		}
	}

	if (self.externals.count > 0) {
		UITableViewController *popoverTable = [[UITableViewController alloc] init];
		popoverTable.tableView.dataSource = self;
		popoverTable.tableView.delegate = self;
		popoverTable.preferredContentSize = CGSizeMake(944, (self.externals.count + 2) * 70);

		self.externalsPopover = [[UIPopoverController alloc] initWithContentViewController:popoverTable];
		[self.externalsPopover presentPopoverFromRect:CGRectMake(512, 144, 1, 1)
											   inView:self.view
							 permittedArrowDirections:UIPopoverArrowDirectionUp
											 animated:YES];
		self.externalsPopover.passthroughViews = nil;
	}
}

- (IBAction) close:(id)sender {
	[[UIApplication sharedApplication] setStatusBarHidden:NO
											withAnimation:UIStatusBarAnimationSlide];
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction) save:(id)sender {
	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;

	for (Element *e in self.operation.elements) {
		[ctx deleteObject:e];
	}
	[ctx save:NULL];

	[self.dictElementView removeAllObjects];
	[self.dictViewElement removeAllObjects];

	for (UIView *view in self.elements) {
		if (self.mainView.frame.size.width < view.frame.origin.x) {
			continue;
		}

		Element *element = [NSEntityDescription insertNewObjectForEntityForName:ELEMENT
														 inManagedObjectContext:ctx];
		element.name = ((id<PluralElement>)view).elementText;
		element.frame = NSStringFromCGRect(view.frame);
		element.type = @(getElementType((id<PluralElement>)view));
		element.operation = self.operation;
		[self.operation addElementsObject:element];

		self.dictElementView[@[element]] = view;
		self.dictViewElement[@[view]] = element;
	}

	[self.intLinkLayers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		NSArray *array = key;

		Element *startElement = self.dictViewElement[@[array[0]]];
		Element *endElement = self.dictViewElement[@[array[1]]];
		[startElement addOutLinksObject:endElement];
	}];

	[self.extLinkLayers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		NSArray *array = key;
		
		Element *startElement = self.dictViewElement[@[array[0]]];
		Role *role = array[2];
		startElement.externalLinkTo = role;
		[role addLinkedElementsObject:startElement];

		RoleElement *endElement = array[1];
		[[NSUserDefaults standardUserDefaults] setObject:NSStringFromCGRect(endElement.frame)
												  forKey:concat(startElement.name, role.name)];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}];
	
	[self.incLinkLayers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		NSArray *array = key;
		
		InformationItemElement *startElement = array[0];
		ActivityElement *endElement = array[1];
		
		Element *iieElement = self.dictExternals[@[startElement]];
		Element *aeElement = self.dictViewElement[@[endElement]];
		aeElement.externalLinkFrom = iieElement;
	}];

	NSError *error = nil;
	if (![ctx save:&error]) {
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
																	   message:error.description
																preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Dismiss"
												  style:UIAlertActionStyleDefault
												handler:^(UIAlertAction * action) {
												}]];
		[self presentViewController:alert animated:YES completion:nil];
	}
	else {
		if (sender) {
			[self showTemporaryAlert:@"Model saved successfully!"];
		}
	}
	
}

- (IBAction) switchChanged {
	self.linkStartElement = nil;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	NSLog(@"What the Heck!!! Memory warning received!!!");
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint position = [touch locationInView:self.view];

	if (CGRectContainsPoint(self.elementsLibrary.frame, position)) {
		if (self.lineSwitch.on) {
			return;
		}
		
		CGPoint relPosition = [touch locationInView:self.elementsLibrary];

		UIView *touchedElement = [self getElementFrom:self.libraryElements on:relPosition];
		if (!touchedElement) {
			return;
		}

		NSString *tmpTitle = @"";
		if ([touchedElement isKindOfClass:[OperatorElement class]]) {
			tmpTitle = ((id<PluralElement>)touchedElement).elementText;
		}

		self.tmpElement = [[[touchedElement class] alloc] initWithTitle:tmpTitle frame:touchedElement.frame];
	}
	else if (CGRectContainsPoint(self.mainView.frame, position)) {
		CGPoint relPosition = [touch locationInView:self.mainView];
		
		UIView *touchedElement = [self getElementFrom:self.elements on:relPosition];
		if (!touchedElement) {
			if (self.tmpElement) {
				self.tmpElement.tag = -2;
			}
			return;
		}

		if (self.lineSwitch.on) {
			drawing = YES;
			startPoint = touchedElement.center;
			self.linkStartElement = touchedElement;
		}
		else {
			self.tmpElement = touchedElement;
			self.tmpElement.tag = -1; // Not a new element
		}
	}
	else if (CGRectContainsPoint(self.leftInteracts.frame, position) || CGRectContainsPoint(self.rightInteracts.frame, position)) {
		if (self.tmpElement) {
			self.tmpElement.tag = -2;
		}
	}
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.tmpElement && !self.lineSwitch.on) {
		return;
	}

	UITouch *touch = [[event allTouches] anyObject];

	if (self.lineSwitch.on && drawing) {
		if (!self.linkStartElement) {
			return;
		}

		[lineLayer removeFromSuperlayer];
		lineLayer = nil;

		UIBezierPath *path = [UIBezierPath bezierPath];
		[path moveToPoint:startPoint];
		[path addLineToPoint:[touch locationInView:self.mainView]];
		[path closePath];

		lineLayer = [self createNewLayerWithPath:path];
		lineLayer.lineWidth = 1.0;
		[self.mainView.layer addSublayer:lineLayer];
	}
	else {
		if (self.tmpElement.tag == -1) {
			self.tmpElement.center = [touch locationInView:self.mainView];

			[self.intLinkLayers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
				NSArray *array = key;
				if ([array containsObject:self.tmpElement]) {
					CAShapeLayer *layer = obj;
					layer.path = [self pathFrom:array[0] to:array[1]].CGPath;
				}
			}];

			[self.extLinkLayers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSArray *array = key;
                UIView *startElement = array[0];
                UIView *endElement = array[1];
				NSNumber *toLeft;
				if (array.count == 4) {
					toLeft = array[3];
				}

                CAShapeLayer *layer = obj;

                if (startElement == self.tmpElement) {
					CGRect relFrame = startElement.frame;
					CGRect rect = CGRectMake(relFrame.origin.x + 158, relFrame.origin.y + 147,
											 relFrame.size.width, relFrame.size.height);
					UIView *mockStartView = [[UIView alloc] initWithFrame:rect];

					UIView *mockEndView;
					if (toLeft) {
						CGRect endFrame = endElement.frame;
						if (toLeft.boolValue) {
							mockEndView = [[UIView alloc] initWithFrame:CGRectMake(endFrame.origin.x + 15, endFrame.origin.y + 147,
																				   endFrame.size.width, endFrame.size.height)];
						}
						else {
							mockEndView = [[UIView alloc] initWithFrame:CGRectMake(endFrame.origin.x + 882, endFrame.origin.y + 147,
																				   endFrame.size.width, endFrame.size.height)];
						}
					}

					if (mockEndView) {
						layer.path = [self pathFrom:mockStartView to:mockEndView].CGPath;
					}
					else {
						layer.path = [self pathFrom:mockStartView to:endElement].CGPath;
					}
                }
            }];

			[self.incLinkLayers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSArray *array = key;
                UIView *startElement = array[0];
                UIView *endElement = array[1];
                CAShapeLayer *layer = obj;

                UIView *mockStartView;
                if (endElement == self.tmpElement) {
                    if (startElement.superview == self.leftInteracts) {
                        CGRect relStartFrame = startElement.frame;
                        CGRect startRect = CGRectMake(relStartFrame.origin.x + 15, relStartFrame.origin.y + 147,
                                                 relStartFrame.size.width, relStartFrame.size.height);
                        mockStartView = [[UIView alloc] initWithFrame:startRect];
                    }
                    else if (startElement.superview == self.rightInteracts) {
                        CGRect relStartFrame = startElement.frame;
                        CGRect startRect = CGRectMake(relStartFrame.origin.x + 882, relStartFrame.origin.y + 147,
                                                      relStartFrame.size.width, relStartFrame.size.height);
                        mockStartView = [[UIView alloc] initWithFrame:startRect];
                    }

                    CGRect relEndFrame = endElement.frame;
                    CGRect endRect = CGRectMake(relEndFrame.origin.x + 158, relEndFrame.origin.y + 147,
                                                relEndFrame.size.width, relEndFrame.size.height);
                    UIView *mockEndView = [[UIView alloc] initWithFrame:endRect];

                    layer.path = [self pathFrom:mockStartView to:mockEndView].CGPath;
                }
			}];
		}
		else if (self.tmpElement.tag == 0) {
			self.tmpElement.center = [touch locationInView:self.view];
			[self.view addSubview:self.tmpElement];
			[self.view bringSubviewToFront:self.tmpElement];
		}
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.tmpElement && !self.lineSwitch.on) {
		return;
	}

	if (self.tmpElement && self.tmpElement.tag == -2) {
		self.tmpElement.tag = 0;
		return;
	}

	UITouch *touch = [[event allTouches] anyObject];
	CGPoint position = [touch locationInView:self.view];

	if (CGRectContainsPoint(self.mainView.frame, position)) {
		CGPoint relPosition = [touch locationInView:self.mainView];

		if (self.lineSwitch.on && drawing) {
			for (UIView *e in self.elements) {
				if (CGRectContainsPoint(e.frame, relPosition)) {
					if (self.linkStartElement == e) {
						continue;
					}

					UIBezierPath *path = [self pathFrom:self.linkStartElement to:e];

					CAShapeLayer *newlineLayer = [self createNewLayerWithPath:path];
					[self.mainView.layer addSublayer:newlineLayer];
					self.intLinkLayers[@[self.linkStartElement, e]] = newlineLayer;
					break;
				}
			}
			[self endDrawing];

			return;
		}

		if (!self.tmpElement) {
			return;
		}

		if (self.tmpElement.tag == -1) {
			self.tmpElement.center = relPosition;
			self.tmpElement.tag	= 0;
		}
		else {
			// Offset for mainview relative to self.view
			CGRect newFrame = CGRectMake(self.tmpElement.frame.origin.x - 158,
										 self.tmpElement.frame.origin.y - 147,
										 self.tmpElement.frame.size.width,
										 self.tmpElement.frame.size.height);

			if ([self.tmpElement isKindOfClass:[OperatorElement class]]) {
				OperatorElement *newElement = [[OperatorElement alloc] initWithTitle:((OperatorElement*)self.tmpElement).elementText
																			   frame:newFrame];
				[self.elements addObject:newElement];
				[self.mainView addSubview:newElement];
				[self.mainView bringSubviewToFront:newElement];

				[self.tmpElement removeFromSuperview];
				self.tmpElement = nil;

				[self save:nil];
			}
			else {
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
																			   message:@"Please enter text for this item"
																		preferredStyle:UIAlertControllerStyleAlert];
				
				[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {}];
				[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
					[self.tmpElement removeFromSuperview];
					self.tmpElement = nil;
				}]];
				[alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
					UITextField *tf = alert.textFields.firstObject;
					
					if (tf.text.length > 0) {
						UIView *newElement = [[[self.tmpElement class] alloc] initWithTitle:tf.text frame:newFrame];
						[self.elements addObject:newElement];
						[self.mainView addSubview:newElement];
						[self.mainView bringSubviewToFront:newElement];
					}
					[self.tmpElement removeFromSuperview];
					self.tmpElement = nil;

					[self save:nil];
				}]];
				
				[self presentViewController:alert animated:YES completion:NULL];
			}
		}
	}
    else if ((self.lineSwitch.on && drawing) && (CGRectContainsPoint(self.leftInteracts.frame, position) || CGRectContainsPoint(self.rightInteracts.frame, position))) {

		if ([self.linkStartElement isKindOfClass:[InformationItemElement class]]) {

			UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
																		   message:@"Are you sure to create an external link to a Role?"
																	preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"NO"
													  style:UIAlertActionStyleDestructive
													handler:^(UIAlertAction *action) {
														[self endDrawing];
													}]];
			[alert addAction:[UIAlertAction actionWithTitle:@"YES"
													  style:UIAlertActionStyleDefault
													handler:^(UIAlertAction *action) {
														[self createExternalLinkToPosition:position];
													}]];
			[self presentViewController:alert animated:YES completion:NULL];
		}
		else {
			[self endDrawing];
		}
    }
    else {
		if (self.lineSwitch.on && drawing) {
			[self endDrawing];
		}
		else {
			if (self.tmpElement.tag == -1) {
				[self.elements removeObject:self.tmpElement];
				
				[self.intLinkLayers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
					NSArray *array = key;
					if ([array containsObject:self.tmpElement]) {
						CAShapeLayer *linkLayer = obj;
						[linkLayer removeFromSuperlayer];
						[self.intLinkLayers removeObjectForKey:key];
					}
				}];

				[self showTemporaryAlert:@"Element is removed from the model!"];
			}
			
			[self.tmpElement removeFromSuperview];
			self.tmpElement = nil;

			[self save:nil];
		}
	}
}

- (void) createExternalLinkToPosition:(CGPoint)position {
	NSManagedObjectContext *ctx = [CoreDataContext getContext].managedObjectContext;
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:ROLE];
	req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	
	NSArray *roles = [ctx executeFetchRequest:req error:NULL];
	
	UIAlertController *opts = [UIAlertController alertControllerWithTitle:nil
																  message:@"Please select a Role from the list."
														   preferredStyle:UIAlertControllerStyleActionSheet];
	opts.modalPresentationStyle = UIModalPresentationPopover;
	opts.popoverPresentationController.sourceView = self.view;
	opts.popoverPresentationController.sourceRect = CGRectMake(position.x, position.y, 1, 1);

	for (Role *role in roles) {
		[opts addAction:[UIAlertAction actionWithTitle:role.name
												 style:UIAlertActionStyleDefault
											   handler:^(UIAlertAction *action) {
												   RoleElement *roleElement = [[RoleElement alloc] initWithTitle:role.name frame:CGRectZero];
												   roleElement.center = position;
												   
												   [self.view addSubview:roleElement];
												   [self.view bringSubviewToFront:roleElement];
												   
												   CGRect relFrame = self.linkStartElement.frame;
												   CGRect rect = CGRectMake(relFrame.origin.x + 158, relFrame.origin.y + 147,
																			relFrame.size.width, relFrame.size.height);
												   UIView *mockStartView = [[UIView alloc] initWithFrame:rect];
												   
												   UIBezierPath *path = [self pathFrom:mockStartView to:roleElement];

												   CAShapeLayer *newlineLayer = [self createNewLayerWithPath:path];
												   [self.view.layer addSublayer:newlineLayer];
												   self.extLinkLayers[@[self.linkStartElement, roleElement, role]] = newlineLayer;

												   [self save:nil];
												   [self endDrawing];
											   }]];
	}
	[opts addAction:[UIAlertAction actionWithTitle:@"Cancel"
											 style:UIAlertActionStyleDestructive
										   handler:^(UIAlertAction *action) { [self endDrawing]; }]];
	[self presentViewController:opts animated:YES completion:nil];
}

- (void) drawExternalRole:(Role *)role element:(Element *)element acText:(NSString *)text h:(long)h v:(long)v ex:(BOOL)flag {

	Element *fromIieElement = nil;
	for (Element *e in self.operation.elements) {
		if (e.externalLinkTo && e.externalLinkTo == role) {
			fromIieElement = e;
			break;
		}
	}

	RoleElement *re;
	InformationItemElement *iie;
	CGFloat y = 0;

	if (!fromIieElement) {
		if (v == 0) y = 40;
		else if (v == 1) y = 240;
		else if (v == 2) y = 440;

		re = [[RoleElement alloc] initWithTitle:role.name frame:CGRectZero];
		re.center = CGPointMake(71, y);
		
		iie = [[InformationItemElement alloc] initWithTitle:element.name frame:CGRectZero];
		iie.center = CGPointMake(71, y + 75);
		
		if (h == 0) {
			[self.leftInteracts addSubview:re];
			[self.leftInteracts addSubview:iie];
		}
		else {
			[self.rightInteracts addSubview:re];
			[self.rightInteracts addSubview:iie];
		}
	}
	else {
		CGRect reRect = CGRectFromString([[NSUserDefaults standardUserDefaults] stringForKey:concat(fromIieElement.name, role.name)]);
		if (reRect.origin.x < 158)
			h = 0;
		else if (reRect.origin.x > 882)
			h = 1;
		
		CGRect newReRect;
		
		if (h == 0) {
			newReRect = CGRectMake(reRect.origin.x - 15, reRect.origin.y - 147, reRect.size.width, reRect.size.height);
		}
		else {
			newReRect = CGRectMake(reRect.origin.x - 882, reRect.origin.y - 147, reRect.size.width, reRect.size.height);
		}

		re = [[RoleElement alloc] initWithTitle:role.name frame:newReRect];
		y = re.center.y;

		iie = [[InformationItemElement alloc] initWithTitle:element.name frame:CGRectZero];
		iie.center = CGPointMake(71, y + 75);

		if (h == 0) {
			[self.leftInteracts addSubview:iie];
		}
		else {
			[self.rightInteracts addSubview:iie];
		}
	}

	UIBezierPath *path1 = [self pathFrom:re to:iie];
	CAShapeLayer *linkLayer = [self createNewLayerWithPath:path1];
	if (h == 0) {
		[self.leftInteracts.layer addSublayer:linkLayer];
	}
	else {
		[self.rightInteracts.layer addSublayer:linkLayer];
	}

	ActivityElement *ae;
	if (!flag) {
		ae = [[ActivityElement alloc] initWithTitle:text frame:CGRectZero];
		ae.center = CGPointMake((h == 0) ? 100 : 620, y + 75);
		[self.mainView addSubview:ae];
		[self.elements addObject:ae];
	}
	else {
		for (Element *element in self.operation.elements) {
			if ([element.name isEqualToString:text]) {
				ae = self.dictElementView[@[element]];
				break;
			}
		}
	}

	CGRect startRect, endRect = CGRectMake(ae.frame.origin.x + 158, ae.frame.origin.y + 147, ae.frame.size.width, ae.frame.size.height);
	if (h == 0) {
		startRect = CGRectMake(iie.frame.origin.x + 15, iie.frame.origin.y + 147, iie.frame.size.width, iie.frame.size.height);
	}
	else {
		startRect = CGRectMake(iie.frame.origin.x + 882, iie.frame.origin.y + 147, iie.frame.size.width, iie.frame.size.height);
	}

	UIBezierPath *path2 = [self pathFrom:[[UIView alloc] initWithFrame:startRect] to:[[UIView alloc] initWithFrame:endRect]];
	CAShapeLayer *linkLayer2 = [self createNewLayerWithPath:path2];
	[self.view.layer addSublayer:linkLayer2];
	self.incLinkLayers[@[iie, ae, role, re]] = linkLayer2;

	self.dictExternals[@[iie]] = element;
	if (flag) {
		Element *e = self.dictViewElement[@[ae]];
		self.dictExternals[@[ae]] = e;
	}
	
	[self save:nil];
}

- (void) endDrawing {
	self.linkStartElement = nil;
	drawing = NO;
	if (lineLayer) {
		[lineLayer removeFromSuperlayer];
		lineLayer = nil;
	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}

- (void) showTemporaryAlert:(NSString *)message {
	__block UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.text = message;
	label.font = [UIFont boldSystemFontOfSize:16];
	label.backgroundColor = [UIColor blackColor];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.alpha = 0.5;
	[label sizeToFit];

	label.frame = CGRectMake(0, 0, label.frame.size.width + 20, label.frame.size.height + 16);
	label.center = self.view.center;
	label.layer.cornerRadius = 6;
	label.layer.masksToBounds = YES;
	[self.view addSubview:label];
	[self.view bringSubviewToFront:label];
	
	[UIView animateWithDuration:1.5
					 animations:^{
						 label.alpha = 1;
					 }
					 completion:^(BOOL finished) {
						 [UIView animateWithDuration:1.5 animations:^{
							 label.alpha = 0;
							}
							completion:^(BOOL finished) {
								if (label) {
									[label removeFromSuperview];
									label = nil;
								}
							}];
					 }
	 ];
}

- (CAShapeLayer *) createNewLayerWithPath:(UIBezierPath *)path {
	CAShapeLayer *newLayer = [CAShapeLayer layer];
	newLayer.path = path.CGPath;
	newLayer.strokeColor = [UIColor blackColor].CGColor;
	newLayer.fillColor = [UIColor clearColor].CGColor;
	newLayer.lineWidth = 1.5;
	return newLayer;
}

- (UIBezierPath *) pathFrom:(UIView *)startElement to:(UIView *)endElement {
	NSArray *linkSides = getLinkSides(startElement, endElement);
	LinkSide startLinkSide = ((NSNumber*)linkSides[0]).intValue, endLinkSide = ((NSNumber*)linkSides[1]).intValue;
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	// Find starting point
	CGPoint linkStartPoint = getLinkPoint(startElement.frame, startLinkSide);
	[path moveToPoint:linkStartPoint];

	// Find ending point
	CGPoint endPoint = getLinkPoint(endElement.frame, endLinkSide);

	int cornerCount = getCornerCount(startLinkSide, endLinkSide, startElement, endElement);

	if (cornerCount > 0) {
		NSArray *points = getCornerPoint(cornerCount, startLinkSide, linkStartPoint, endLinkSide, endPoint);
		[path addLineToPoint:CGPointFromString(points[0])];
		
		if (cornerCount > 1) {
			[path addLineToPoint:CGPointFromString(points[1])];
		}
	}

	// Add end point now
	[path addLineToPoint:endPoint];

	// Draw arrow
	[path moveToPoint:endPoint];
	NSArray *arrows = getArrowPoints(endLinkSide, endPoint);
	[path addLineToPoint:CGPointFromString(arrows[0])];
	[path addLineToPoint:CGPointFromString(arrows[1])];
	[path addLineToPoint:endPoint];
	[path closePath];
	
	return path;
}

- (UIView *) getElementFrom:(NSArray *)views on:(CGPoint)point {
	for (UIView *elementView in views) {
		if (CGRectContainsPoint(elementView.frame, point)) {
			return elementView;
		}
	}
	return nil;
}

#pragma mark - Externals popover
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.externals.count + 2;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		static NSString *identifier = @"HeaderCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		}
		cell.textLabel.text = @"You have incoming documents from other operations/roles. Please enter activity text and select positions for the model.";
		cell.textLabel.numberOfLines = 0;
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.font = [UIFont systemFontOfSize:18];
		
		return cell;
	}
	else if (indexPath.row == self.externals.count + 1) {
		static NSString *identifier = @"FooterCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		}
		cell.textLabel.text = @"Continue";
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:24];
		
		return cell;
	}
	else {
		static NSString *identifier = @"ExternalCell";
		ExternalLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

		if (cell == nil) {
			cell = [[ExternalLinkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		}

		NSArray *arr = self.externals[indexPath.row - 1];
		cell.roleElemView.titleLabel.text = ((Role *)arr[0]).name;
		cell.iieElemView.titleLabel.text = ((Element *)arr[1]).name;

		return cell;
	}
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < self.externals.count + 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }

    for (int i = 1; i < self.externals.count + 1; i++) {
        ExternalLinkCell *cell = (ExternalLinkCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];

        NSArray *arr = self.externals[i-1];
		Role *role = arr[0];
		Element *element = arr[1];

		if (cell.decision.selectedSegmentIndex == 1) {
			NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALS_REJECTED];
			if (!array) array = [NSArray array];
			NSMutableArray *newArray = [array mutableCopy];
			[newArray addObject:concat(role.name, element.name)];

			[[NSUserDefaults standardUserDefaults] setObject:newArray forKey:EXTERNALS_REJECTED];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			[self.externalsPopover dismissPopoverAnimated:YES];
			return;
		}
		
		NSString *text = (cell.activityText.text) ? cell.activityText.text : @"Activity";
		long h = (cell.horizontal.selectedSegmentIndex == UISegmentedControlNoSegment) ? 0 : cell.horizontal.selectedSegmentIndex;
		long v = (cell.vertical.selectedSegmentIndex == UISegmentedControlNoSegment) ? 1 : cell.vertical.selectedSegmentIndex;

		[self drawExternalRole:role element:element acText:text h:h v:v ex:NO];

		NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALS];
		if (!array) array = [NSArray array];
		NSMutableArray *newArray = [array mutableCopy];
		[newArray addObject:concat(role.name, element.name)];

		NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:EXTERNALS_DATA];
		if (!dict) dict	= [NSDictionary dictionary];
		NSMutableDictionary *newDict = [dict mutableCopy];
		newDict[concat(role.name, element.name)] = @[text, @(h), @(v)];

		[[NSUserDefaults standardUserDefaults] setObject:newArray forKey:EXTERNALS];
		[[NSUserDefaults standardUserDefaults] setObject:newDict forKey:EXTERNALS_DATA];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }

    [self.externalsPopover dismissPopoverAnimated:YES];
}

@end
