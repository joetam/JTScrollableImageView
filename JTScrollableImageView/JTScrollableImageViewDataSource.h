#import <UIKit/UIKit.h>

typedef void (^ImageHandler)(UIImage *image);

@protocol JTScrollableImageViewDataSource <NSObject>

/**
 *  Clients are responsible for calling 'next' and 'prev' when the UI has completed navigation to the next or the
 *  previous image.
 */
- (void)next;
- (void)prev;

- (NSUInteger)currentIndex;
- (void)currentImage:(ImageHandler)handler;
- (void)prevImage:(ImageHandler)handler;
- (void)nextImage:(ImageHandler)handler;

@optional

- (BOOL)hasNext;
- (BOOL)hasPrev;

@end
