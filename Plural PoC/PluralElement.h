//
//  PluralElement.h
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/20/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

@protocol PluralElement <NSObject>
@required
@property (nonatomic, readonly) NSString *elementText;

- (instancetype) initWithTitle:(NSString *)title frame:(CGRect)frame;
@end