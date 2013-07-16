

#import "UserInfoManager.h"

@implementation UserInfoManager
@synthesize userInfo;
@synthesize shopArray;
@synthesize productArray;

static UserInfoManager *manager=nil;

+ (UserInfoManager*) sharedManager
{
    if(! manager)
    {
        manager=[[self alloc] init];
    }
    return manager;
}

- (id) init
{
    self=[super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData) name:UIApplicationWillResignActiveNotification object:nil];
        self.userInfo=[self getUserData];
        if(!self.userInfo)
        {
            self.userInfo=[UserInfo defaultUserInfo];
        }
        self.shopArray = [self getShopArrayData];
        if (!self.shopArray) {
            self.shopArray = [[NSMutableArray alloc] init];
        }
        self.productArray = [self getProductArrayData];
        if (!self.productArray) {
            self.productArray = [[NSMutableArray alloc] init];
        }
        
    }
    return self;
}

- (void)saveData
{
    [self saveUserData];
    [self saveShopArray];
    [self saveProductArray];
}



#pragma mark - get, save user data
- (UserInfo*) getUserData
{
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:kUSER_DATA];
    if(! data) return nil;
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void) saveUserData
{
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:self.userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUSER_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Shop Array Data

- (NSMutableArray*)getShopArrayData
{
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:kSHOPARRAY_DATA];
    if(! data) return nil;
    return (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}


- (void)saveShopArray
{
    DLog(@"");
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:self.shopArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kSHOPARRAY_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Product Array Data

- (NSMutableArray*)getProductArrayData
{
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:kPRODUCTARRAY_DATA];
    if(! data) return nil;
    return (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}


- (void)saveProductArray
{
    DLog(@"");
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:self.productArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kPRODUCTARRAY_DATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Dic Shop 

- (BOOL) isSaveShop:(NSString*)shopName
{
    return [[self.userInfo.shopDic objectForKey:shopName] boolValue];
}

- (void) setSaveShop:(NSString*)shopName value:(BOOL)value
{
    [self.userInfo.shopDic setObject:[NSNumber numberWithBool:value] forKey:shopName];
}

#pragma mark - Dic Product 

- (BOOL) isSaveProduct:(NSString*)productName
{
    return [[self.userInfo.productDic objectForKey:productName] boolValue];
}

- (void) setSaveProduct:(NSString*)productName value:(BOOL)value
{
    [self.userInfo.productDic setObject:[NSNumber numberWithBool:value] forKey:productName];
}


@end





