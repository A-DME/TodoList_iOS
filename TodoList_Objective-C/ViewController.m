//
//  ViewController.m
//  TodoList_Objective-C
//
//  Created by JETSMobileMini4 on 24/12/2023.
// Todo Screen

#import "ViewController.h"
#import "TodoCell.h"
#import "DetailsViewController.h"
#import "Todohaya.h"
#import "AddViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *todoList;
@property (weak, nonatomic) IBOutlet UISearchBar *search;


@property NSUserDefaults *defaults;
@property NSData *savedData;
@property NSArray<Todohaya*> *todos;
@property NSArray<Todohaya*> *temp;
@property NSMutableArray<Todohaya*> *searched;
@property bool searching;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _todoList.delegate = self;
    _todoList.dataSource = self;
    _defaults = [NSUserDefaults standardUserDefaults];
    
    _search.delegate = self;
    _search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searched = [NSMutableArray new];
    _searching = NO;


}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _searching=YES;
    for (Todohaya *todo in _temp) {
        if([todo.name containsString:[searchText lowercaseString]]){
            if(![_searched containsObject:todo]){
                [_searched addObject:todo];}
        }else{
            [_searched removeObject:todo];
        }
    }
    [_todoList reloadData];
}

-(NSArray<Todohaya*>*)filterToTodoArray:(NSArray<Todohaya*>*) todos{
    NSMutableArray *arr = [NSMutableArray new];
    for (Todohaya *todo in todos) {
        if (todo.status == 0) {
            [arr addObject:todo];
        }
        
    }
    return arr;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count;
    if (_searching && ![_search.text isEqual:@""]) {
        count= _searched.count;
    } else {
        count = _temp.count;
    }
    return count;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
        UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"Delete Cell" message:@"Do you want to delete this cell" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *del = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self->_todos];
            [arr removeObjectAtIndex:[self->_todos indexOfObject:[self->_temp objectAtIndex:indexPath.row]]];
            self->_todos = [NSArray arrayWithArray:arr];
            self->_temp = [self filterToTodoArray:self->_todos];
            NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:self->_todos requiringSecureCoding:YES error:nil];
            
            [self->_defaults setObject:archiveData forKey:@"todoslist"];
            
            [self->_todoList reloadData];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [cont addAction:del];
    [cont addAction:cancel];
    
    [self presentViewController:cont animated:YES completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TodoCell *cell = [self.todoList dequeueReusableCellWithIdentifier:@"todo"];
    NSString *imageName;
    
    if(_searching && ![_search.text isEqual:@""]){
        cell.title.text = _searched[indexPath.row].name;
        switch (_searched[indexPath.row].priority) {
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
    }else{
        _searching=NO;
        [_searched removeAllObjects];
        cell.title.text = _temp[indexPath.row].name;
        switch (_temp[indexPath.row].priority) {
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
    }
    [cell.imgVew setImage:[UIImage imageNamed:imageName]];
    
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    Todohaya *t = _temp[indexPath.row] ;
    [details setTodohaya:t :[_todos indexOfObject:t]];
    [details setScreenIndex:0];
    [self.navigationController pushViewController:details animated:YES];
}

- (IBAction)addTodo:(id)sender {
    AddViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    [self.navigationController pushViewController:details animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    _savedData = [_defaults objectForKey:@"todoslist"];
    
   
    _todos = (NSArray*) [NSKeyedUnarchiver unarchivedArrayOfObjectsOfClass:[Todohaya class] fromData:_savedData error:nil];
    _temp = [self filterToTodoArray:_todos];

    NSLog(@"%lu",[_temp count]);
    NSLog(@"%lu",[_todos count]);
    [_todoList reloadData];
}

@end
