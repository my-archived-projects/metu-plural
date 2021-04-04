//
//  Role.h
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/27/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

@class Element, Operation;

@interface Role : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *linkedElements;
@property (nonatomic, retain) NSSet *operations;
@end

@interface Role (CoreDataGeneratedAccessors)

- (void)addLinkedElementsObject:(Element *)value;
- (void)removeLinkedElementsObject:(Element *)value;
- (void)addLinkedElements:(NSSet *)values;
- (void)removeLinkedElements:(NSSet *)values;

- (void)addOperationsObject:(Operation *)value;
- (void)removeOperationsObject:(Operation *)value;
- (void)addOperations:(NSSet *)values;
- (void)removeOperations:(NSSet *)values;

@end
