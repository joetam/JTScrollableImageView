#import <UIKit/UIKit.h>

@protocol MultiImageDataSource <NSObject>

- (NSUInteger)currentIndex;
- (UIImage *)currentImage;
- (UIImage *)prevImage;
- (UIImage *)nextImage;

- (void)next;
- (void)prev;

@end
