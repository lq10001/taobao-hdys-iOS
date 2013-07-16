
#import <Foundation/Foundation.h>

@interface Product : NSObject

@property(assign)int productid;
@property(assign)int cid;
@property(assign)int num;
@property(nonatomic,strong)NSString *num_iid;

@property(nonatomic,strong)NSString *price ;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *pic_url ;
@property(nonatomic,strong)NSString *title ;
@property(nonatomic,strong)NSString *nick ;



@end
