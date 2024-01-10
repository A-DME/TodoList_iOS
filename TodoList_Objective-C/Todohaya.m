//
//  Todohaya.m
//  TodoList_Objective-C
//
//  Created by JETSMobileMini4 on 24/12/2023.
//

#import "Todohaya.h"

@implementation Todohaya

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_desc forKey:@"description"];
    [coder encodeInt:_priority forKey:@"priority"];
    [coder encodeInt:_status forKey:@"status"];
    [coder encodeObject:_date forKey:@"date"];
}

- (id)initWithCoder:(nonnull NSCoder *) coder {
    if(self = [super init]){
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _desc = [coder decodeObjectOfClass:[NSString class] forKey:@"description"];
        _priority = [coder decodeIntForKey:@"priority"];
        _status = [coder decodeIntForKey:@"status"];
        _date = [coder decodeObjectOfClass:[NSDate class] forKey:@"date"];
        
        
    }
    return self;
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

- (BOOL)isSameAs:(Todohaya*) todohaya{
    bool result = NO;
    if(
          [self.name isEqual:todohaya.name]
       && [self.desc isEqual:todohaya.desc] 
       && self.priority == todohaya.priority
       && self.status == todohaya.status
       && [self.date isEqualToDate:todohaya.date]
       ){
        result = YES;
    }
    return result;
}
@end
