//
//  STARScaleDelegate.h
//  StarMgsIO
//

#import <Foundation/Foundation.h>

@class STARScale, STARScaleData;

typedef NS_ENUM(NSUInteger, STARScaleSetting);


@protocol STARScaleDelegate <NSObject>

- (void)scale:(STARScale *)scale didReadScaleData:(STARScaleData *)scaleData error:(NSError *)error;

- (void)scale:(STARScale *)scale didUpdateSetting:(STARScaleSetting)setting error:(NSError *)error;

@end
