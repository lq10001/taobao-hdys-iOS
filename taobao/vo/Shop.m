
#import "Shop.h"

#define kNAME       @"name"
#define kPIC_URL    @"pic_url"
#define kURL        @"shop_url"


@implementation Shop

@synthesize name;
@synthesize pic_url;
@synthesize shop_url;

#pragma mark - NSCoding
- (id) initWithCoder:(NSCoder *)decoder
{
    self=[super init];
    if(self)
    {
        self.name=[decoder decodeObjectForKey:kNAME];
        self.pic_url = [decoder decodeObjectForKey:kPIC_URL];
        self.shop_url = [decoder decodeObjectForKey:kURL];
        
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)enCoder
{
    [enCoder encodeObject:self.name forKey:kNAME];
    [enCoder encodeObject:self.pic_url forKey:kPIC_URL];
    [enCoder encodeObject:self.shop_url forKey:kURL];
}


@end
