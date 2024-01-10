//
//  Todohaya.h
//  TodoList_Objective-C
//
//  Created by JETSMobileMini4 on 24/12/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Todohaya : NSObject <NSCoding,NSSecureCoding>
@property NSString *name;
@property NSString *desc;
@property int priority;
@property int status;
@property NSDate *date;

//- (void)encodeWithCoder:(NSCoder *)encoder;
- (BOOL)isSameAs:(Todohaya*) todohaya;

@end

NS_ASSUME_NONNULL_END
