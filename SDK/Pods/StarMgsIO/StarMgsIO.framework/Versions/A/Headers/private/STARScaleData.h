//
//  STARScaleData.h
//  StarMgsIO
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, STARUnit) {
    STARUnitInvalid,
    STARUnitMG,
    STARUnitG,
    STARUnitCT,
    STARUnitMOM,
    STARUnitOZ,
    STARUnitLB,
    STARUnitOZT,
    STARUnitDWT,
    STARUnitGN,
    STARUnitTLH,
    STARUnitTLS,
    STARUnitTLT,
    STARUnitTO,
    STARUnitMSG,
    STARUnitBAT,
    STARUnitPCS,
    STARUnitPercent,
    STARUnitCoefficient 
};

typedef NS_ENUM(NSUInteger, STARComparatorResult) {
    STARComparatorResultInvalid,
    STARComparatorResultShortage,
    STARComparatorResultProper,
    STARComparatorResultOver
};

typedef NS_ENUM(NSUInteger, STARDataType) {
    STARDataTypeInvalid,
    STARDataTypeNetNotTared,
    STARDataTypeNet,
    STARDataTypeTare,
    STARDataTypePresetTare,
    STARDataTypeTotal,
    STARDataTypeUnit,
    STARDataTypeGross
};

typedef NS_ENUM(NSUInteger, STARStatus) {
    STARStatusInvalid,
    STARStatusStable,
    STARStatusUnstable,
    STARStatusError,
};


@interface STARScaleData : NSObject

@property(nonatomic, readonly) NSString *rawString;

@property(nonatomic, readonly) double weight;

@property(nonatomic, readonly) STARUnit unit;

@property(nonatomic, readonly) STARComparatorResult comparatorResult;

@property(nonatomic, readonly) STARDataType dataType;

@property(nonatomic, readonly) STARStatus status;

@property(nonatomic, readonly) NSInteger numberOfDecimalPlaces;

@end
