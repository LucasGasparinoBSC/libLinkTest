project(app)

file(GLOB_RECURSE SRC_FILES ${CMAKE_CURRENT_LIST_DIR}/*.f90)

#include_directories(${lib1_INCLUDE_DIRS} ${lib2_INCLUDE_DIRS} ${lib3_INCLUDE_DIRS})
include_directories(${lib3_INCLUDE_DIRS})

add_executable(${PROJECT_NAME} ${SRC_FILES})

#target_link_libraries(${PROJECT_NAME} lib1 lib2 lib3)
target_link_libraries(${PROJECT_NAME} lib3)

set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME "app_F90")

install(TARGETS ${PROJECT_NAME} DESTINATION bin)