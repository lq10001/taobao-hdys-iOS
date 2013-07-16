
#import "UserInfo.h"


#define kSHOP_DIC   @"shop_dic"
#define kPRODUCT_DIC   @"product_dic"
#define kCLOTHES_UNLOCK   @"clothes_unlock"



@implementation UserInfo

@synthesize shopDic;
@synthesize productDic;

+ (UserInfo*) defaultUserInfo
{
    UserInfo *userInfo=[[self alloc] init];
    userInfo.shopDic=[NSMutableDictionary dictionary];
    userInfo.productDic=[NSMutableDictionary dictionary];
    return userInfo;
}


#pragma mark - NSCoding
- (id) initWithCoder:(NSCoder *)decoder
{
    self=[super init];
    if(self)
    {
        self.shopDic=[decoder decodeObjectForKey:kSHOP_DIC];
        self.productDic = [decoder decodeObjectForKey:kPRODUCT_DIC];
        
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)enCoder
{
    [enCoder encodeObject:self.shopDic forKey:kSHOP_DIC];
    [enCoder encodeObject:self.productDic forKey:kPRODUCT_DIC];
}


@end
