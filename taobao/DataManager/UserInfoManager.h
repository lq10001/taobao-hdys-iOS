
#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface UserInfoManager : NSObject
{
}

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) NSMutableArray *productArray;



+ (UserInfoManager*) sharedManager;

//data get,set
- (UserInfo*) getUserData;

- (BOOL) isSaveShop:(NSString*)shopName;
- (void) setSaveShop:(NSString*)shopName value:(BOOL)value;

- (BOOL) isSaveProduct:(NSString*)productName;
- (void) setSaveProduct:(NSString*)productName value:(BOOL)value;



- (void) saveUserData;

- (void)saveShopArray;


@end
