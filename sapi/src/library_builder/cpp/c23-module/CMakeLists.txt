cmake_minimum_required(VERSION 3.28)

# 确保CMake版本≥3.25（推荐3.28+）‌
# 编译器需支持C++20/26模块（GCC≥15或Clang≥15）‌
# 必须使用Ninja作为生成器
set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_MODULE_STD ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
#set(CMAKE_CXX_EXTENSIONS OFF)
#set(CMAKE_CXX_SCAN_FOR_MODULES ON)
set(CMAKE_EXPERIMENTAL_CXX_MODULE_STD ON)

# 详情 https://github.com/Kitware/CMake/blob/master/Help/dev/experimental.rst
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "3c375311-a3c9-4396-a187-3227ef642046")


# 设置模块缓存路径
#set(GCM_CACHE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/gcm.cache")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -B${GCM_CACHE_PATH}")

# file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/gcm.cache)
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fmodules -B${CMAKE_BINARY_DIR}/gcm.cache")
#add_compile_options(-fmodules)

#if (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
#    add_compile_options(-fmodules -B${GCM_CACHE_PATH})
#    add_link_options(-fmodules -B${GCM_CACHE_PATH})
#endif ()


# add_library(__CMAKE::CXX26 INTERFACE IMPORTED)
project(untitled LANGUAGES CXX)
add_executable(untitled main.cpp)

# target_compile_options(untitled  PRIVATE -fmodules )

