//
//  BasicViewController.m
//  TemplateObjCiOS
//
//  Created by Dio Brand on 2023/3/17.
//

#import "BasicViewController.h"
#import "AllFunction.h"
#import "PersonModle.h"

@interface BasicViewController ()

@property (weak, nonatomic) IBOutlet UILabel *show;
@property(nonatomic,strong)AllFunction *allfunction;

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基础方法";
    self.allfunction = [[AllFunction alloc]init];
}

/****************** 类方法 ********************/
// 类方法 无参数 有返回值
- (IBAction)hookClassFuncNOparam:(UIButton *)sender {
    NSString *tmp = [AllFunction sharedInstance];
    [self.show setText:tmp];
}
// 类方法 无参数 有返回值 为数字类型
- (IBAction)classFuncRetNumber:(UIButton *)sender {
    long number = [AllFunction sharedRetNumber];
    NSString *text = [NSString stringWithFormat:@"10 is origin value:%ld",number];
    [self.show setText:text];
}
// 类方法 参数和返回值为 NSString
- (IBAction)hookClassFunc:(UIButton *)sender {
    NSString *tmp = [AllFunction sharedInstance:@"ClassFuncP1" param2:@"ClassFuncP2" param3:@"ClassFuncP3"];
    [self.show setText:tmp];
}

// 实例方法 无参 有返回值
- (IBAction)instanceFunc:(UIButton *)sender {
    int number = [self.allfunction funcNoParam];
    NSString *text = [NSString stringWithFormat:@"10 is origin value:%d",number];
    [self.show setText:text];
}

// 实例方法 有1个参数 有返回值
- (IBAction)instanceFunc2:(UIButton *)sender {
    int number = [self.allfunction funcOneParam:2];
    NSString *text = [NSString stringWithFormat:@"20 is origin value:%d",number];
    [self.show setText:text];
}

// 实例方法 有多个参数 有返回值
- (IBAction)instanceManyParam:(UIButton *)sender {
    int number = [self.allfunction funcManyParam:1 param2:2 param3:3];
    NSString *text = [NSString stringWithFormat:@"6 is origin value:%d",number];
    [self.show setText:text];
}

// 参数和返回值为 NSString
- (IBAction)nsstringHandle:(UIButton *)sender {
    NSString *text = [self.allfunction funcNSStringHandle:@"string1111" param2:@"string2222" param3:@"string3333"];
    [self.show setText:text];
}

// 参数为 NSObject
- (IBAction)paramNSObject:(UIButton *)sender {
    PersonModle *person = [[PersonModle alloc] init];
    person.name = @"Dio";
    person.gender = 1;
    person.height = 180.0;
    NSString *text = [self.allfunction funcParamObject:person];
    [self.show setText:text];
}

- (IBAction)paramBlock:(UIButton *)sender {
    /*
     [downloadManager downloadWithURL: url parameters:para handler:^(NSData *receiveData, NSError *error) {
     if (error) {
     NSLog(@"下载失败：%@",error);
     }else {
     NSLog(@"下载成功，%@",receiveData);
     }
     }];
     **/
    
    //另一种写法,将block声明、实现和方法调用分开来写,这样写便于理解
    //    int (^handler)(NSString * response, NSError * error);//block的声明
    int (^handler)(int, int) = ^int(int num1, int num2){//block的实现
        return num1 + num2;
    };
    
    /*
     //也可以用 typedef 定义的 DownloadHandler
     DownloadHandler handler = ^(NSData * receiveData, NSError * error){
     if (error) {
     NSLog(@"下载失败：%@",error);
     }else {
     NSLog(@"下载成功，%@",receiveData);
     }
     };
     **/
    
    int number = [self.allfunction blockAsParam:1 num2:2 handler:handler];
    NSString *text = [NSString stringWithFormat:@"230 is origin value:%d",number];
    [self.show setText:text];
}


struct teststruct {
    char    machine[0x200];
};
// 定义一个 C 函数 第一个参数为 struct 指针,
int mycfunc(struct teststruct * stru,char *s) {
    size_t len = 0x100;
    char str[len];
    bzero(str, len);
    char *mach = "A string from c function.";
    strcat(str, mach);
    strcat(str, s);
    printf("str:%s\n",str);
    memcpy(&(stru->machine),str,len);
    return 0;
}
- (IBAction)cfunction:(UIButton *)sender {
    struct teststruct stru;
    memset(&stru, 0, sizeof(struct teststruct));
    char *s = "||origin param2";
    mycfunc(&stru,s);
    NSString *string = [[NSString alloc] initWithCString:stru.machine encoding:NSUTF8StringEncoding];
    NSLog(@"0x%lx, %@", string.length, string);
    [self.show setText:string];
}

@end
