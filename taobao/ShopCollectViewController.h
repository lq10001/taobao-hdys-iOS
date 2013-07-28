

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@interface ShopCollectViewController : ParentViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *shopTableView;
}

@property(nonatomic,strong)NSMutableArray *shopCollectArray;

@end
