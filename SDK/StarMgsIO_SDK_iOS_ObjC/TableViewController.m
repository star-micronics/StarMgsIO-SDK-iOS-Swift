//
//  TableViewController.m
//  StarMgsIO_SDK_iOS_ObjC
//

#import "TableViewController.h"

#import "SubViewController.h"

@import CoreBluetooth;


@interface TableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *manualInputButton;

@property (nonatomic) NSMutableArray<STARScale *> *contents;

@property (nonatomic) STARScale *connectedScale;

@property (strong, nonatomic) void (^disconnectionHandler)(void);

@property (strong, nonatomic) CBCentralManager *centralmanager;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    STARDeviceManager.sharedManager.delegate = self;
    
    _contents = [NSMutableArray new];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _centralmanager = [[CBCentralManager alloc] initWithDelegate:self
                                                           queue:queue];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_centralmanager.state == CBCentralManagerStatePoweredOn) {
        [STARDeviceManager.sharedManager scanForScales];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contents.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    STARScale *selectedScale = _contents[indexPath.row];
    
    [STARDeviceManager.sharedManager connectScale:selectedScale];
    
    [tableView setUserInteractionEnabled:NO];
    _manualInputButton.enabled = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScaleInfoCell"
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = _contents[indexPath.row].name;
    cell.detailTextLabel.text = _contents[indexPath.row].identifier;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SubViewController *subVC = (SubViewController *)segue.destinationViewController;
    
    subVC.scale = _connectedScale;
    
    subVC.scale.delegate = subVC;
    
    __typeof(self) __weak wself = self;
    _disconnectionHandler = ^{
        [wself.navigationController popViewControllerAnimated:YES];
    };
}


#pragma mark - STARDeviceManagerDelegate

- (void)manager:(STARDeviceManager *)manager didDiscoverScale:(STARScale *)scale error:(NSError *)error {
    if (error) {
        [self showSimpleAlertWithTitle:@"Failed"
                               message:error.localizedDescription
                           buttonTitle:@"OK"];
        return;
    }
    
    [_contents addObject:scale];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_contents.count - 1
                                                inSection:0];

    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
}

- (void)manager:(STARDeviceManager *)manager didConnectScale:(STARScale *)scale error:(NSError *)error {
    [self.tableView setUserInteractionEnabled:YES];
    _manualInputButton.enabled = YES;
    
    if (error) {
        [self showSimpleAlertWithTitle:@"Failed to connect"
                               message:error.localizedDescription
                           buttonTitle:@"OK"];
        return;
    }
    
    _connectedScale = scale;
    
    // Open sub view
    [self performSegueWithIdentifier:@"ShowSubViewSegue" sender:self];
    
    // Stop scan and clear table view.
    [STARDeviceManager.sharedManager stopScan];
    [_contents removeAllObjects];
    [self.tableView reloadData];
}

- (void)manager:(STARDeviceManager *)manager didDisconnectScale:(STARScale *)scale error:(NSError *)error {
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    if (_disconnectionHandler != nil) {
        _disconnectionHandler();
    }
}


#pragma mark -

- (IBAction)inputScaleIdentifierManually:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Input Scale Identifier"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         if (alert.textFields.firstObject == nil) {
                                                             return;
                                                         }
                                                         
                                                         NSString *uuid = alert.textFields.firstObject.text;
                                                         
                                                         [STARDeviceManager.sharedManager connectScaleWithIdentifier:uuid];
    }];
    [alert addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSimpleAlertWithTitle:(nullable NSString *)title
                         message:(nullable NSString *)message
                     buttonTitle:(nonnull NSString *)buttonTitle {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [STARDeviceManager.sharedManager scanForScales];
            break;
        default:
            [STARDeviceManager.sharedManager stopScan];
            [_contents removeAllObjects];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
            break;
    }
}

@end
