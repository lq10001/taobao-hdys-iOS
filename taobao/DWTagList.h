

#import <UIKit/UIKit.h>

@protocol DWTagListDelegate <NSObject>

@optional

- (void)onTag:(int)index;

@end

@interface DWTagList : UIView<DWTagListDelegate>
{
    UIView *view;
    NSArray *textArray;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
}
@property (nonatomic, unsafe_unretained)id<DWTagListDelegate> delegate;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;

- (void)setLabelBackgroundColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;

@end
