//
//  ExternalLinkCell.h
//  Plural PoC
//
//  Created by Metehan Karabiber on 5/10/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

@class RoleElement, InformationItemElement;

@interface ExternalLinkCell : UITableViewCell

@property (nonatomic) RoleElement *roleElemView;
@property (nonatomic) InformationItemElement *iieElemView;
@property (nonatomic) UISegmentedControl *horizontal, *vertical, *decision;
@property (nonatomic) UITextField *activityText;

@end
