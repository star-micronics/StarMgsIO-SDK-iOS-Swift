//
//  STARScaleType.h
//  StarMgsIO
//
//  Created by i2biz-dev on 2021/08/02.
//  Copyright © 2021 u3237. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, STARScaleType_ENUM) {
    STARScaleTypeInvalid = 0,
    STARScaleTypeMGS = 1,
    STARScaleTypeMGTS = 2,
};

@interface STARScaleType : NSObject

+(STARScaleType_ENUM) getEnum:(NSString *)name;

@end


