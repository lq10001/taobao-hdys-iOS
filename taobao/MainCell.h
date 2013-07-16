
#import <UIKit/UIKit.h>

@interface MainCell : UITableViewCell

@property(nonatomic,assign)int index;

- (void)loadView:(NSString*)imageName title:(NSString*)title price:(NSString*)price;


@end
