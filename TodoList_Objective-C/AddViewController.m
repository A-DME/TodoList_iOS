//
//  AddViewController.m
//  TodoList_Objective-C
//
//  Created by JETSMobileMini4 on 24/12/2023.
//

#import "AddViewController.h"
#import "Todohaya.h"

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *status;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDate;



@property NSUserDefaults *defaults;
@property NSData *savedData;
@property NSArray<Todohaya*> *todos;


@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dueDate.minimumDate = [NSDate date];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    
    
    
}

- (IBAction)addTodo:(id)sender {
    Todohaya *todo = [Todohaya new];
    if(![[_nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""]){
        todo.name = _nameField.text;
        todo.desc = _descriptionField.text;
        todo.priority = _priority.selectedSegmentIndex;
        todo.status = _status.selectedSegmentIndex;
        todo.date = _dueDate.date;
        
        NSString *key = @"todoslist";
    //    switch (_priority.selectedSegmentIndex) {
    //        case 0:
    //            key = @"Highlist";
    //            break;
    //        case 1:
    //            key = @"Mediumlist";
    //            break;
    //        case 2:
    //            key = @"Lowlist";
    //            break;
    //
    //        default:
    //            break;
    //    }
        _savedData = [_defaults objectForKey:key];
        
        NSError *err;
        _todos = (NSArray*) [NSKeyedUnarchiver unarchivedArrayOfObjectsOfClass:[Todohaya class] fromData:_savedData error:&err];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_todos];
        [arr addObject:todo];
        _todos = [NSArray arrayWithArray:arr];
        
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:_todos requiringSecureCoding:YES error:&err];
        
        [_defaults setObject:archiveData forKey:key];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"Insufficient data" message:@"Please enter a name for the todo" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [cont addAction:ok];
        [self presentViewController:cont animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [_status removeSegmentAtIndex:2 animated:YES];
    [_status removeSegmentAtIndex:1 animated:YES];
}


@end
