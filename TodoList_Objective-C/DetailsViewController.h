//
//  DetailsViewController.h
//  TodoList_Objective-C
//
//  Created by JETSMobileMini4 on 24/12/2023.
//

#import <UIKit/UIKit.h>
#import "Todohaya.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
- (void)setTodohaya:(Todohaya *)t : (int)index;
-(void)setScreenIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
