//
//  Target.c
//  TargetObjCHook
//
//  Created by zd on 20/3/2024.
//

#include "Target.h"

int add(int a,int b) {
    printf("%s:%d -------> add -- 111 go here !", __FILE__, __LINE__);
    int c = a * b + 0x10;
    printf("%s:%d -------> add --- 222 go here !", __FILE__, __LINE__);
    return c;
}
