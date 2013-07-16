
#import <UIKit/UIKit.h>

@protocol PersonViewDelegate <NSObject>

- (void)personRtn:(int)index;

@end

@interface PersonView : UIView

@property(nonatomic,assign)id<PersonViewDelegate> delegate;

@end
