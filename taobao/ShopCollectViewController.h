

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@interface ShopCollectViewController : ParentViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    UITableView *shopTableView;
    bool isDel;
}

@property(nonatomic,strong)NSMutableArray *shopCollectArray;

@end
