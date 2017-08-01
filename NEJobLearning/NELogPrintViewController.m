//
//  NELogPrintViewController.m
//  NEJobLearning
//
//  Created by neareast on 2017/7/27.
//  Copyright © 2017年 neareast. All rights reserved.
//

#import "NELogPrintViewController.h"

#define NEPrintLog 1
#define ViewLog(FORMAT, ...) [self logPrintString:[NSString stringWithFormat:FORMAT, ##__VA_ARGS__]]

extern NSString *globalStr;
extern NSString *constStr;
extern NSString *constStrP;
//！！编译报错；其它模块定义的static变量不可引用；可以定义同名static变量
//extern NSString *staticStr;
static NSString *staticStr;

@interface NELogPrintViewController ()

@property (weak, nonatomic) IBOutlet UITextView *txtViewLogPrint;
@property (nonatomic, copy) void(^mBlock)();

@end

//类外方法使用
static __weak NELogPrintViewController *thisVC;

@implementation NELogPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    thisVC = self;
    [self.txtViewLogPrint addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    
    NSLog(@"-------------- global variables test -------------------\n");

    NSLog(@"[%p]globalStr: %@\n", globalStr, globalStr);
    NSLog(@"[%p]constStr: %@\n", constStr, constStr);
    NSLog(@"[%p]constStrP: %@\n", constStrP, constStrP);
    NSLog(@"[%p]staticStr: %@\n", staticStr, staticStr);
    globalStr = @"new globalStr";
    constStr = @"new constStr";
    //如果不是NSString，其他类型强行赋值会崩溃；所以extern的声明应与原变量保持完全一致，以免不必要的后果
    constStrP = @"new constStrP";;
    staticStr = @"new staticStr";
    
    NSLog(@"[%p]new globalStr: %@\n", globalStr, globalStr);
    NSLog(@"[%p]new constStr: %@\n", constStr, constStr);
    NSLog(@"[%p]new constStrP: %@\n", constStrP, constStrP);
    NSLog(@"[%p]staticStr: %@\n", staticStr, staticStr);
    

    NSLog(@"-------------- block test -------------------\n");
    [self blockTest];

    
    NSLog(@"-------------- gcd test -------------------\n");

    //5、 创建参数需大于等于0；否则创建失败
    dispatch_semaphore_t s = dispatch_semaphore_create(0);
    //返回0表示成功，非0表示失败
    long r = dispatch_semaphore_wait(s, DISPATCH_TIME_NOW);
    NSLog(@"dispatch_semaphore_wait result %ld\n", r);
    
    
    
    NSLog(@"---------------- other test ---------------------\n");
    NSData *data = [[NSData alloc] init];
    //6、 任意遵循NSCopying协议的类型都可以作为字典的Key
    NSDictionary *dic = @{data:@"data from data key", @"data": @"data from string key"};
    NSLog(@"%@\n%@\n", [dic objectForKey:data], [dic objectForKey:@"data"]);
    
    [self performSelectorInBackground:@selector(testRunloop) withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - inner methods
- (void)logPrintString:(NSString *)str {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.txtViewLogPrint.text = [self.txtViewLogPrint.text stringByAppendingFormat:@"%@\n", str];
    });
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"bounds"]) {
        NSLog(@"%@ change from %@ to %@", keyPath, [change valueForKey:NSKeyValueChangeNewKey], [change valueForKey:NSKeyValueChangeNewKey]);
        ;
    }
}

#pragma mark - test methods
- (void)blockTest {
    //1 __NSGlobalBlock__  全局block   存储在代码区（存储方法或者函数）
    void(^myBlock1)() = ^() {
        NSLog(@"我是老大");
    };
    NSLog(@"%@\n",myBlock1);
    
    //2 __NSStackBlock__  栈block  存储在栈区；ARC中为自动释放的__NSMallocBlock
    //block内部访问外部变量
    //block的本质是一个结构体
    int n = 5;
    void(^myBlock2)() = ^() {
        NSLog(@"我是老二%d", n);
    };
    NSLog(@"%@\n", myBlock2);
    
    
    //3 __NSMallocBlock__  堆block 存储在堆区  对栈block做一次copy操作
    void(^myBlock3)() = ^() {
        NSLog(@"我是老三%d", n);
    };
    NSLog(@"%@\n", [myBlock3 copy]);
    
    
    /*
     由以上三个例子可以看出当block没有访问外界的变量时,是存储在代码区,
     当block访问外界变量时时存储在栈区, 而此时的block出了作用域就会被释放
     以下示例:
     */
    [self blockMemoryTest];//当此代码结束时,blockTest函数中的所有存储在栈区的变量都会被系统释放, 因此如果属性的block是用assign修饰时,当再次访问时就会出现野指针访问.
    self.mBlock();
    
    //MRC下崩溃：error: returning block that lives on the local stack.
    blockClosureTest();
}

- (void)blockMemoryTest {
    int n = 5;
    __weak typeof(self) weakSelf = self;
    [self setMBlock:^{
        [weakSelf logPrintString:[NSString stringWithFormat:@"int in block%d",n]];;
    }];
    NSLog(@"test--%@\n",self.mBlock);
}

//4、 MRC和ARC对局部Stack的处理不同；ARC中，局部Stack被标记为autorelease的NSMallocBlock
//http://blog.devtang.com/2013/07/28/a-look-inside-blocks/
//http://blog.parse.com/learn/engineering/objective-c-blocks-quiz/
typedef void (^dBlock)();
dBlock getBlock() {
    char *d = "heap in ARC, stack in MRC\n";
    return ^{
        printf("%s", d);
    };
}

void blockClosureTest() {
    getBlock()();
}

#pragma mark - runloop
//7、runloop状态监听测试
- (void)testRunloop {
    // 获取当前线程的Run Loop
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    // 创建一个Run Loop 观察者对象；观察事件为每次循环的所有活动；
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    if (observer) {
        // 将Cocoa的NSRunLoop类型转换成Core Foundation的CFRunLoopRef类型
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        // 添加观察才对象到该Run Loop 上
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                   selector:@selector(doFireTimer:) userInfo:nil repeats:YES];
    // 重复启动Run Loop 2次
    NSInteger loopCount = 2;
    do {
        //启动 Run Loop 开始循环，直到指定的时间才结束，这里就是持续1秒；
        //当调用RunUnitDate方法时，观察者检测到循环已经启动，开始根据循环的各个阶段的事件，调用上面注册的myRunLoopObserver回调函数。
        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        // 运行完之后，会再一次调用回调函数，状态是KFRunLoopExit,表示循环结束。
        loopCount--;
    } while(loopCount);
    
    printf("The End.\n");
}

- (void)doFireTimer:(NSTimer *)timer {
    [thisVC logPrintString:@"fire timer"];
}
// Run loop观察者的回调函数：
void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry: {
            [thisVC logPrintString:@"run loop entry"];
            break;
        }
        case kCFRunLoopBeforeTimers: {
            [thisVC logPrintString:@"run loop before timers"];
            break;
        }
        case kCFRunLoopBeforeSources: {
            [thisVC logPrintString:@"run loop before sources"];
            break;
        }
        case kCFRunLoopBeforeWaiting: {
            [thisVC logPrintString:@"run loop before waiting"];
            break;
        }
        case kCFRunLoopAfterWaiting: {
            [thisVC logPrintString:@"run loop after waiting"];
            break;
        }
        case kCFRunLoopExit:{
            [thisVC logPrintString:@"run loop exit"];
            break;
        }
        default:
            break;
    }
}

@end
