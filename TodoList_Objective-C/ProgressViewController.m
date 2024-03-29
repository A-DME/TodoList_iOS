//
//  ProgressViewController.m
//  TodoList_Objective-C
//
//  Created by JETSMobileMini4 on 24/12/2023.
//

#import "ProgressViewController.h"
#import "TodoCell.h"
#import "Todohaya.h"
#import "DetailsViewController.h"

@interface ProgressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *progressList;

@property NSUserDefaults *defaults;
@property NSData *savedData;
@property NSArray<Todohaya*> *todos;
@property NSArray<Todohaya*> *todosInProgress;
@property NSArray<Todohaya*> *htodos;
@property NSArray<Todohaya*> *mtodos;
@property NSArray<Todohaya*> *ltodos;
@property NSArray<NSArray<Todohaya*>*> *temp;
@property bool withSection;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _progressList.delegate = self;
    _progressList.dataSource = self;
    
    _defaults = [NSUserDefaults standardUserDefaults];
    _withSection = NO;
    
}

- (NSArray*)filterToProgressArray:(NSArray<Todohaya*>*)todoslist{
    NSMutableArray *pArr = [NSMutableArray new];
    for (Todohaya *todo in todoslist) {
        if (todo.status == 1) {
            [pArr addObject:todo];
        }
    }
    return [NSArray arrayWithArray: pArr];
}

- (NSArray*)filterToSectionArray:(NSArray<Todohaya*>*)todoslist : (int)priority{
    NSMutableArray *section = [NSMutableArray new];
    for (Todohaya *todo in todoslist) {
        if (todo.priority == priority) {
            [section addObject:todo];
        }
    }
    return [NSArray arrayWithArray: section];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _withSection ? 3 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int number;
    if(_withSection){
        switch (section) {
            case 0:
                number = _htodos.count;
                break;
            case 1:
                number = _mtodos.count;
                break;
            case 2:
                number = _ltodos.count;
                break;
                
            default:
                number = 0;
                break;
        }
    }else{
        number = _todosInProgress.count;
    }
    return number;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
        UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"Delete Cell" message:@"Do you want to delete this cell" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *del = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self->_todos];
            
            Todohaya *toRemove;
            if (self->_withSection) {
                toRemove = self->_temp[indexPath.section][indexPath.row];
            } else {
                toRemove = self->_todosInProgress[indexPath.row];
            }
            
            
            [arr removeObjectAtIndex:[self->_todos indexOfObject:toRemove]];
            
            self->_todos = [NSArray arrayWithArray:arr];
            NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:self->_todos requiringSecureCoding:YES error:nil];
            
            [self->_defaults setObject:archiveData forKey:@"todoslist"];
            
            [self loadTable];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [cont addAction:del];
    [cont addAction:cancel];
    
    [self presentViewController:cont animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TodoCell *cell = [_progressList dequeueReusableCellWithIdentifier:@"cell"];
    
    NSString *cellName;
    int cellPriority;
    if (_withSection) {
        cellName = _temp[indexPath.section][indexPath.row].name;
        cellPriority = _temp[indexPath.section][indexPath.row].priority;
    } else {
        cellName = _todosInProgress[indexPath.row].name;
        cellPriority = _todosInProgress[indexPath.row].priority;

    }
    
    cell.title.text = cellName;
    NSString *imageName;
    switch (cellPriority) {
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
    [cell.imgVew setImage:[UIImage imageNamed:imageName]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    
    Todohaya *t;
    if (_withSection) {
        t = _temp[indexPath.section][indexPath.row];
    } else {
        t = _todosInProgress[indexPath.row];
    }
    
    [details setTodohaya:t :(int)[_todos indexOfObject:t]];
    [details setScreenIndex:1];
    [self.navigationController pushViewController:details animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    if (!_withSection) {
        title = nil;
    }else{
        switch (section) {
            case 0:
                title = @"High Priority";
                break;
            case 1:
                title = @"Medium Priority";
                break;
            case 2:
                title = @"Low Priority";
                break;
                
            default:
                break;
        }
    }
    
    return title;
}
- (IBAction)filterTodos:(id)sender {
    _withSection = ! _withSection;
    [self loadTable];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadTable];
}

- (void)loadTable{
    _savedData = [_defaults objectForKey:@"todoslist"];
    
    NSError *err;
    
    _todos = (NSArray*) [NSKeyedUnarchiver unarchivedArrayOfObjectsOfClass:[Todohaya class] fromData:_savedData error:&err];
    _todosInProgress = [self filterToProgressArray:_todos];
    if(_withSection){
        _htodos = [self filterToSectionArray: _todosInProgress :0];
        _mtodos = [self filterToSectionArray: _todosInProgress :1];
        _ltodos = [self filterToSectionArray: _todosInProgress :2];
        
        _temp = @[_htodos,_mtodos,_ltodos];
    }
    [_progressList reloadData];
}
@end
