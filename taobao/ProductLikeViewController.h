

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@interface ProductLikeViewController : ParentViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *productTableView;
}

@end
