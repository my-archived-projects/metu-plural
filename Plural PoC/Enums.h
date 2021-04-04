//
//  Enums.h
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/19/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

typedef NS_ENUM(NSInteger, PluralElementType) {
	PluralActivityElement,
	PluralRoleElement,
	PluralEventElement,
	PluralInformationItemElement,
	PluralOperatorElement
};

typedef NS_ENUM(NSInteger, PluralLinkType) {
	PluralInternalLink,
	PluralExternalLink
};

typedef NS_ENUM(int, LinkSide) {
	TOP, LEFT, BOTTOM, RIGHT
};
