//
//  main.cpp
//  BMP
//
//  Created by john gospai on 2019/10/12.
//  Copyright © 2019 john gospai. All rights reserved.
//

#include <iostream>
#include "BMP.h"
class A{
public:
    int a = 10;
};
using namespace std;
int main(int argc, const char * argv[]) {
    // insert code here...
    cout << "Hello, World!\n";
    A a = A();
    cout << a.a;
    BMP b = BMP("bmp-file-35273.bmp");
    
    
    return 0;
}
