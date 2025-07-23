//#include <iostream>
//
//int main() {
//    std::cout << "Hello, World!" << std::endl;
//    return 0;
//}

import std;

int main() {
    std::cout << "__cplusplus:" << __cplusplus << std::endl ;
#if __cplusplus >= 202302L
    std::cout << "C++23 supported (__cplusplus=" << __cplusplus << ")\n";
#else
    std::cout << "C++23 not fully supported\n";
#endif
    std::println("hello world");
}