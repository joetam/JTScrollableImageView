#import "ImageProvider.h"

const NSString *URLString1 = @"https://scontent-ord1-1.xx.fbcdn.net/t39.2365-6/13679843_1433045310042694_2044999515_n.jpg";
const NSString *URLString2 = @"https://scontent-ord1-1.xx.fbcdn.net/t39.2365-6/13679837_1101895823190612_932461675_n.jpg";
const NSString *URLString3 = @"https://scontent-ord1-1.xx.fbcdn.net/t39.2365-6/13640651_1653363894977744_738647184_n.jpg";
const NSString *URLString4 = @"https://scontent-ord1-1.xx.fbcdn.net/t39.2365-6/13911044_264029583981700_1832665714_n.jpg";

@interface ImageProvider ()

@property (nonatomic, strong) NSArray *URLs;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation ImageProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *URLStrings = @[URLString1, URLString2, URLString3, URLString4];
        NSMutableArray *temp = [NSMutableArray new];
        for (NSString *string in URLStrings) {
            [temp addObject:[NSURL URLWithString:string]];
        }
        _URLs = [NSArray arrayWithArray:temp];
        _cache = [NSMutableDictionary new];
    }
    return self;
}

- (NSURL *)URLForImageAtIndex:(NSUInteger)index
{
    return self.URLs[index];
}

- (NSUInteger)numberOfImages
{
    return [self.URLs count];
}

- (UIImage *)currentImage
{
    return [self imageForIndex:self.currentIndex];
}

- (UIImage *)nextImage
{
    if (self.currentIndex + 1 < self.URLs.count) {
        return [self imageForIndex:self.currentIndex + 1];
    }
    return nil;
}

- (UIImage *)prevImage
{
    if (self.currentIndex - 1 >= 0) {
        return [self imageForIndex:self.currentIndex - 1];
    }
    return nil;
}

- (UIImage *)imageForIndex:(NSUInteger)index;
{
    NSURL *imageURL = self.URLs[index];
    if (self.cache[imageURL]) {
        return self.cache[imageURL];
    } else {
        [self fetchImageForURL:imageURL];
        // need an error-out condition otherwise it could loop forever
        return [self imageForIndex:index];
    }
}

- (void)next
{
    self.currentIndex += 1;
    // prefetch
    if (self.currentIndex + 1 < self.URLs.count) {
        [self fetchImageForURL:self.URLs[self.currentIndex+1]];
    }
}

- (void)prev
{
    self.currentIndex -= 1;
    // prefetch
    if (self.currentIndex - 1 >= 0) {
        [self fetchImageForURL:self.URLs[self.currentIndex-1]];
    }
}

- (void)fetchImageForURL:(NSURL *)URL
{
    if (!URL) {
        return;
    }

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // TODO: make async
        UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:URL]];
        self.cache[URL] = downloadedImage;
//    });
}

@end
