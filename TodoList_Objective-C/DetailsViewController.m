//
//  DetailsViewController.m
//  TodoList_Objective-C
//
//  Created by JETSMobileMini4 on 24/12/2023.
//

#import "DetailsViewController.h"


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *status;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIButton *theButton;
@property (weak, nonatomic) IBOutlet UIImageView *priorityIcon;



@property NSUserDefaults *defaults;
@property NSData *savedData;
@property NSArray *todos;

@property int screen;



@property Todohaya *todo;
@property int index;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _defaults = [NSUserDefaults standardUserDefaults];
    _savedData = [_defaults objectForKey:@"todoslist"];
    
    NSError *err;
    _todos = (NSArray*) [NSKeyedUnarchiver unarchivedArrayOfObjectsOfClass:[Todohaya class] fromData:_savedData error:&err];
    
}

- (IBAction)editButton:(id)sender {
    if(![[_nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""]){
        Todohaya *todo = [Todohaya new];
        todo.name = _nameField.text;
        todo.desc = _descriptionField.text;
        todo.priority = _priority.selectedSegmentIndex;
        todo.status = _status.selectedSegmentIndex;
        todo.date = _date.date;
        bool x = [todo isSameAs:_todo];
        if(!x){
            UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"Edit Confirmation" message:@"Are you sure you want to edit the task?" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self->_todos];
                [arr replaceObjectAtIndex:self->_index withObject:todo];
                self->_todos = [NSArray arrayWithArray:arr];
                
                NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:self->_todos requiringSecureCoding:YES error:nil];
                
                [self->_defaults setObject:archiveData forKey:@"todoslist"];
                
               
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
            
            [cont addAction:yes];
            [cont addAction:no];
            [self presentViewController:cont animated:YES completion:nil];
        }else{
            UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"No Change" message:@"No edit has been done!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            [cont addAction:ok];
            [self presentViewController:cont animated:YES completion:nil];
        }
        
    }else{
        UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"Name error" message:@"Please supply a name for the todo" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [cont addAction:ok];
        [self presentViewController:cont animated:YES completion:nil];
    }
}

-(void)setFields:(Todohaya*) t{
    _nameField.text = t.name;
    _descriptionField.text = t.desc;
    [_priority setSelectedSegmentIndex:t.priority];
    [_status setSelectedSegmentIndex:t.status];
    [_date setDate:t.date];
    _date.minimumDate = NSDate.now;
    NSString *imageName;
    switch (t.priority) {
        case 0:
            imageName = @"high priority";
            break;
        case 1:
            imageName = @"medium priority";
            break;
        case 2:
            imageName = @"low priority";
            break;
            
        default:
            break;
    }
    [_priorityIcon setImage:[UIImage imageNamed:imageName]];
}

- (void)setTodohaya:(nonnull Todohaya *)t : (int)index{
    _todo = t;
    _index = index;
}

-(void)setScreenIndex:(int)index{
    _screen = index;
}

- (void)viewWillAppear:(BOOL)animated{
    [self setFields:_todo];
    switch (_screen) {
        case 0:

            break;
        case 1:
            [_status setEnabled:NO forSegmentAtIndex:0];
            break;
        case 2:
            [_theButton setHidden:YES];
            [_nameField setEnabled:NO];
            [_descriptionField setEnabled:NO];
            [_priority setEnabled:NO];
            [_status setEnabled:NO];
            [_date setEnabled:NO];
            
            break;
            
        default:
            break;
    }
    
}


@end
