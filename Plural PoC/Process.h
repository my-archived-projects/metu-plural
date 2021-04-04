//
//  Process.h
//  Plural PoC
//
//  Created by Metehan Karabiber on 4/19/15.
//  Copyright (c) 2015 SM589 Term Project. All rights reserved.
//

@interface Process : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *operations;
@end

@interface Process (CoreDataGeneratedAccessors)

- (void)addOperationsObject:(NSManagedObject *)value;
- (void)removeOperationsObject:(NSManagedObject *)value;
- (void)addOperations:(NSSet *)values;
- (void)removeOperations:(NSSet *)values;

@end
