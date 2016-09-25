#import <UIKit/UIKit.h>

@protocol MultiImageDataSource <NSObject>

- (NSUInteger)currentIndex;
//- (NSUInteger)numberOfImages;
//- (NSURL *)URLForImageAtIndex:(NSUInteger)index;
- (UIImage *)currentImage;
- (UIImage *)prevImage;
- (UIImage *)nextImage;

- (void)next;
- (void)prev;

@end
