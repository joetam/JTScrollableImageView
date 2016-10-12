#import "JTScrollableImageProvider.h"

@interface JTScrollableImageProvider ()

@property (nonatomic, strong) NSArray *URLs;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation JTScrollableImageProvider

- (instancetype)initWithURLs:(NSArray *)imageURLs
{
    self = [super init];
    if (self) {
        _URLs = imageURLs;
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

- (void)imageForIndex:(NSInteger)index imageHandler:(ImageHandler)handler
{
    if (index < 0 || index >= self.URLs.count) {
        if (handler) {
            handler(nil);
        }
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURL *imageURL = self.URLs[index];
        if (self.cache[imageURL]) {
            if (handler) {
                handler(self.cache[imageURL]);
            }
        } else {
            [self fetchImageForURL:imageURL imageHandler:^(UIImage *image) {
                self.cache[imageURL] = image;
                if (handler) {
                    handler(image);
                }
            }];
        }
    });
}

- (void)fetchImageForURL:(NSURL *)URL imageHandler:(ImageHandler)handler
{
    if (!URL) {
        handler(nil);
        return;
    }

    UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:URL]];
    if (handler) {
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(q, ^{
            handler(downloadedImage);
        });
    }
}

#pragma mark - MultiImageDataSource

- (void)currentImage:(ImageHandler)handler
{
    [self imageForIndex:self.currentIndex imageHandler:handler];
}

- (void)nextImage:(ImageHandler)handler
{
    [self imageForIndex:self.currentIndex+1 imageHandler:handler];
}

- (void)prevImage:(ImageHandler)handler
{
    [self imageForIndex:self.currentIndex-1 imageHandler:handler];
}

- (void)next
{
    self.currentIndex += 1;
    // prefetch
    [self imageForIndex:self.currentIndex+1 imageHandler:nil];
}

- (void)prev
{
    self.currentIndex -= 1;
    // prefetch
    [self imageForIndex:self.currentIndex-1 imageHandler:nil];
}

- (BOOL)hasNext
{
    return self.currentIndex < self.URLs.count - 1;
}

- (BOOL)hasPrev
{
    return self.currentIndex > 0;
}

@end
