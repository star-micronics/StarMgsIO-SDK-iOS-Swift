//
//  SubViewController.m
//  StarMgsIO_SDK_iOS_ObjC
//

#import "SubViewController.h"
#import "BorderedButton.h"

@interface SubViewController ()

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *dataTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *comparatorResultLabel;

@property (weak, nonatomic) IBOutlet BorderedButton *zeroPointAdjustmentButton;

@property (nonatomic) NSDictionary<NSNumber *, NSString *> *unitDict;

@property (nonatomic) NSDictionary<NSNumber *, NSString *> *statusDict;

@property (nonatomic) NSDictionary<NSNumber *, NSString *> *dataTypeDict;

@property (nonatomic) NSDictionary<NSNumber *, NSString *> *comparatorResultDict;

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDictionaries];
}

- (void)viewWillDisappear:(BOOL)animated {
    [STARDeviceManager.sharedManager disconnectScale:_scale];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initDictionaries {
    _unitDict = @{@(STARUnitInvalid): @"Invalid",
                  @(STARUnitMG): @"mg",
                  @(STARUnitG): @"g",
                  @(STARUnitKG): @"kg",
                  @(STARUnitCT): @"ct",
                  @(STARUnitMOM): @"mom",
                  @(STARUnitOZ): @"oz",
                  @(STARUnitLB): @"lb",
                  @(STARUnitOZT): @"ozt",
                  @(STARUnitDWT): @"dwt",
                  @(STARUnitGN): @"gr",
                  @(STARUnitTLH): @"tl",
                  @(STARUnitTLS): @"tl",
                  @(STARUnitTLT): @"tl",
                  @(STARUnitTO): @"tola",
                  @(STARUnitMSG): @"msg",
                  @(STARUnitBAT): @"bht",
                  @(STARUnitPCS): @"PCS",
                  @(STARUnitPercent): @"%",
                  @(STARUnitCoefficient): @"MUL"};
    
    _statusDict = @{@(STARStatusStable): @"Stable",
                    @(STARStatusError): @"Error",
                    @(STARStatusInvalid): @"Invalid",
                    @(STARStatusUnstable): @"Unstable"};
    
    _comparatorResultDict = @{@(STARComparatorResultInvalid): @"Invalid",
                              @(STARComparatorResultShortage): @"Shortage",
                              @(STARComparatorResultProper): @"OK",
                              @(STARComparatorResultOver): @"Over"};
    
    _dataTypeDict = @{@(STARDataTypeInvalid): @"Invalid",
                      @(STARDataTypeNetNotTared): @"NetNotTared",
                      @(STARDataTypeNet): @"Net",
                      @(STARDataTypeTare): @"Tare",
                      @(STARDataTypePresetTare): @"PresetTare",
                      @(STARDataTypeTotal): @"Total",
                      @(STARDataTypeUnit): @"Unit",
                      @(STARDataTypeGross): @"Gross"};
}

- (IBAction)performZeroPointAdjustment:(id)sender {
    self.zeroPointAdjustmentButton.enabled = NO;
    
    [_scale updateSetting:STARScaleSettingZeroPointAdjustment];
}


#pragma mark - STARScaleDelegate

- (void)scale:(STARScale *)scale didReadScaleData:(STARScaleData *)scaleData error:(NSError *)error {
    if (error) {
        return;
    }
    
    _weightLabel.text = [NSString stringWithFormat:@"%.*lf [%@]",
                         (int)scaleData.numberOfDecimalPlaces,
                         scaleData.weight,
                         _unitDict[@(scaleData.unit)]];
    
    _statusLabel.text = [NSString stringWithFormat:@"Status: %@", _statusDict[@(scaleData.status)]];
    
    _dataTypeLabel.text = [NSString stringWithFormat:@"Data Type: %@", _dataTypeDict[@(scaleData.dataType)]];
    
    _comparatorResultLabel.text = [NSString stringWithFormat:@"Comparator Result: %@",
                                   _comparatorResultDict[@(scaleData.comparatorResult)]];
    
    // Not available for MGTS.
    if (scale.scaleType && scale.scaleType == STARScaleTypeMGTS) {
        _comparatorResultLabel.hidden = true;
    } else {
        _comparatorResultLabel.hidden = false;
    }
}

- (void)scale:(STARScale *)scale didUpdateSetting:(STARScaleSetting)setting error:(NSError *)error {
    self.zeroPointAdjustmentButton.enabled = YES;
    
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed"
                                                                       message:error.localizedDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSLog(@"%s: Success", __PRETTY_FUNCTION__);
}

@end
