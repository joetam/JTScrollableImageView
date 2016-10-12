#import "ViewController.h"
#import "JTScrollableImageView.h"
#import "ImageProvider.h"

@interface ViewController ()

@property (nonatomic, strong) JTScrollableImageView *imageView;
@property (nonatomic, strong) ImageProvider *imageProvider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];

    self.imageView = [JTScrollableImageView new];
    self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 330);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageProvider = [ImageProvider new];
    self.imageView.dataSource = self.imageProvider;
    [self.view addSubview:self.imageView];
}

@end
