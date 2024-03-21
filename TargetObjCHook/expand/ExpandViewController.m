//
//  ExpandViewController.m
//  TemplateObjCiOS
//
//  Created by Dio Brand on 2023/3/17.
//

#import "ExpandViewController.h"
#import <mach-o/loader.h>
#import <mach-o/dyld.h>
#include "Target.h"

static unsigned long func_vaddr;
@interface ExpandViewController ()
{
    unsigned long main_module_vaddr;
}

@property (weak, nonatomic) IBOutlet UILabel *show;

@end

@implementation ExpandViewController

// objc 类里的 C 函数会 内嵌到 objc 的调用方法里,不会单独生成一个函数
int add2(int a,int b) {
    //    printf("-------> add2 vaddr:%p\n",add2);
    func_vaddr = (unsigned long)&add2;
    printf("%s:%d -------> add2 111 go here !", __FILE__, __LINE__);
    int c = a * b + 0x10;
    printf("%s:%d -------> add2 222 go here !", __FILE__, __LINE__);
    return c;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    int c = add2(0x12, 0x13);
//    NSString *tip = [NSString stringWithFormat:@"%d",c];
    [self.show setText:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扩展";
    
    const char *module = "TargetObjCHook";
    
    const struct mach_header *image_header = NULL;
    const char *image_name = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        image_name = _dyld_get_image_name(i);
        if(strstr(image_name, module) != NULL) { // 这里采用模匹配,模块名包含module即返回
            image_header = _dyld_get_image_header(i);
            main_module_vaddr = (unsigned long)image_header;
        }
    }
}

- (IBAction)call_c_func:(UIButton *)sender {
    int a = 0x11;
    int b = 0x22;
    int c = add(a, b);
    
    NSString *tip = [NSString stringWithFormat:@"&add vaddr:%p main module vaddr:0x%lX add offset:0x%lx add(0x%x,0x%x) = 0x%x",add,main_module_vaddr,((unsigned long)&add - main_module_vaddr), a, b, c];
    [self.show setText:tip];
}

- (IBAction)call_func_c2_act:(UIButton *)sender {
    int a = 0x33;
    int b = 0x44;
    int c = add2(a, b);
    
    NSString *tip = [NSString stringWithFormat:@"&add2 vaddr:0x%lx main module vaddr:0x%lX add offset:0x%lx add2(0x%x,0x%x) = 0x%x",func_vaddr,main_module_vaddr,(func_vaddr - main_module_vaddr), a, b, c];
    [self.show setText:tip];
}

@end
