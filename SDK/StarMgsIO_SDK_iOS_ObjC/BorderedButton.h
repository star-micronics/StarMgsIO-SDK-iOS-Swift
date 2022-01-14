//
//  BorderedButton.h
//  StarMgsIO_SDK_iOS_ObjC
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BorderedButton : UIButton

@property(nonatomic) IBInspectable CGFloat cornerRadius;

@property(nonatomic) IBInspectable UIColor *borderColor;

@property(nonatomic) IBInspectable CGFloat borderWidth;



@end
