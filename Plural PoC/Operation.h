//
//  Operation.h
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/27/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

@class Element, Process, Role;

@interface Operation : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *elements;
@property (nonatomic, retain) Process *process;
@property (nonatomic, retain) Role *role;
@end

@interface Operation (CoreDataGeneratedAccessors)

- (void)addElementsObject:(Element *)value;
- (void)removeElementsObject:(Element *)value;
- (void)addElements:(NSSet *)values;
- (void)removeElements:(NSSet *)values;

@end
