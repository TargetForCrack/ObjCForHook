//
//  ExpandViewController.m
//  TemplateObjCiOS
//
//  Created by Dio Brand on 2023/3/17.
//

#import "ExpandViewController.h"
#import <mach-o/loader.h>
#import <mach-o/dyld.h>

@interface ExpandViewController ()

@property (weak, nonatomic) IBOutlet UILabel *show;

@end

@implementation ExpandViewController

int add(int a,int b) {
    return (a + b);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扩展";
}

- (IBAction)call_c_func:(UIButton *)sender {
    int a = 10;
    int b = 20;
    int c = add(a, b);
    
    const char *module = "TargetObjCHook";
    
    unsigned long main_module_vaddr = 0;
    const struct mach_header *image_header = NULL;
    const char *image_name = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        image_name = _dyld_get_image_name(i);
        if(strstr(image_name, module) != NULL) { // 这里采用模匹配,模块名包含module即返回
            image_header = _dyld_get_image_header(i);
            main_module_vaddr = (unsigned long)image_header;
        }
    }
    
    NSString *tip = [NSString stringWithFormat:@"&add vaddr:%p main module vaddr:0x%lX add offset:0x%lx add(%d,%d) = %d",add,main_module_vaddr,((unsigned long)&add - main_module_vaddr), a, b, c];
    [self.show setText:tip];
}

@end
