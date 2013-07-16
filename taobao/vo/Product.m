

#import "Product.h"

#define kPID        @"kPID"
#define kCID        @"kCID"
#define kNUM        @"kNUM"
#define kNUM_IID    @"kNUM_IID"
#define kPRICE      @"kPRICE"
#define kURL        @"kURL"
#define kPIC_URL    @"kPIC_URL"
#define kTITLE      @"kTITLE"
#define kNICK       @"kNICK"


@implementation Product

@synthesize productid;
@synthesize cid;
@synthesize num;
@synthesize num_iid;

@synthesize price ;
@synthesize url;
@synthesize pic_url ;
@synthesize title ;
@synthesize nick ;

#pragma mark - NSCoding
- (id) initWithCoder:(NSCoder *)decoder
{
    self=[super init];
    if(self)
    {
        self.productid = [decoder decodeIntForKey:kPID];
        self.cid = [decoder decodeIntForKey:kCID];
        self.num = [decoder decodeIntForKey:kNUM];
        self.num_iid = [decoder decodeObjectForKey:kNUM_IID];
        
        self.price=[decoder decodeObjectForKey:kPRICE];
        self.url = [decoder decodeObjectForKey:kURL];
        self.pic_url = [decoder decodeObjectForKey:kPIC_URL];
        self.title = [decoder decodeObjectForKey:kTITLE];
        self.nick = [decoder decodeObjectForKey:kNICK];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)enCoder
{
    [enCoder encodeInt:self.productid forKey:kPID];
    [enCoder encodeInt:self.cid forKey:kCID];
    [enCoder encodeInt:self.num forKey:kNUM];
    [enCoder encodeObject:self.num_iid forKey:kNUM_IID];
    
    [enCoder encodeObject:self.price forKey:kPRICE];
    [enCoder encodeObject:self.url forKey:kURL];
    [enCoder encodeObject:self.pic_url forKey:kPIC_URL];
    [enCoder encodeObject:self.title forKey:kTITLE];
    [enCoder encodeObject:self.nick forKey:kNICK];
    
}

@end
