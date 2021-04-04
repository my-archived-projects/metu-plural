//
//  Element.h
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/27/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

@class Element, Operation, Role;

@interface Element : NSManagedObject

@property (nonatomic, retain) NSString * frame;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Element *externalLinkFrom;
@property (nonatomic, retain) Role *externalLinkTo;
@property (nonatomic, retain) Operation *operation;
@property (nonatomic, retain) NSSet *outLinks;
@end

@interface Element (CoreDataGeneratedAccessors)

- (void)addOutLinksObject:(Element *)value;
- (void)removeOutLinksObject:(Element *)value;
- (void)addOutLinks:(NSSet *)values;
- (void)removeOutLinks:(NSSet *)values;

@end
