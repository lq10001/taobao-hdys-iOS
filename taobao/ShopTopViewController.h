

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@interface ShopTopViewController : ParentViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *shopTableView;
    NSDictionary *adDic;
}

@property(nonatomic,strong)NSMutableArray *shopArray;


@end
