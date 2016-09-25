#import "ViewController.h"
#import "ScrollableImageView.h"
#import "ImageProvider.h"

@interface ViewController ()

@property (nonatomic, strong) ScrollableImageView *imageView;
@property (nonatomic, strong) ImageProvider *imageProvider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];

    self.imageView = [ScrollableImageView new];
    self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 330);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageProvider = [ImageProvider new];
    self.imageView.dataSource = self.imageProvider;
    [self.view addSubview:self.imageView];
}

@end
