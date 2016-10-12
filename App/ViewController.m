#import "ViewController.h"
#import "JTScrollableImageView.h"
#import "JTScrollableImageProvider.h"

const NSString *URLString1 = @"https://scontent-ord1-1.xx.fbcdn.net/t39.2365-6/13679843_1433045310042694_2044999515_n.jpg";
const NSString *URLString2 = @"https://scontent-ord1-1.xx.fbcdn.net/t39.2365-6/13679837_1101895823190612_932461675_n.jpg";
const NSString *URLString3 = @"https://scontent-ord1-1.xx.fbcdn.net/t39.2365-6/13640651_1653363894977744_738647184_n.jpg";
const NSString *URLString4 = @"https://scontent-ord1-1.xx.fbcdn.net/t39.2365-6/13911044_264029583981700_1832665714_n.jpg";

@interface ViewController ()

@property (nonatomic, strong) JTScrollableImageView *imageView;
@property (nonatomic, strong) JTScrollableImageProvider *imageProvider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:79/255.0 alpha:1.0];

    NSArray *temp = @[URLString1, URLString2, URLString3, URLString4];
    NSMutableArray *URLs = [NSMutableArray new];
    for (NSString *s in temp) {
        [URLs addObject:[NSURL URLWithString:s]];
    }

    self.imageView = [JTScrollableImageView new];
    self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 330);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageProvider = [[JTScrollableImageProvider alloc] initWithURLs:URLs];
    self.imageView.dataSource = self.imageProvider;
    [self.view addSubview:self.imageView];
}

@end
