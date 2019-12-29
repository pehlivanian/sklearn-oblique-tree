cmake_minimum_required(VERSION 3.7.0 FATAL_ERROR)
project(generate_data LANGUAGES C)

set(ADDL_LINK_FLAGS "-lm")
set(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${ADDL_LINK_FLAGS}")

# Extras
message(STATUS "Is the C compiler loaded? ${CMAKE_C_COMPILER_LOADED}")
if(CMAKE_C_COMPILER_LOADED)
  message(STATUS "The C compiler ID is: ${CMAKE_C_COMPILER_ID}")
  message(STATUS "Is the C from GNU? ${CMAKE_COMPILER_IS_GNUCC}")
  message(STATUS "The C compiler version is: ${CMAKE_C_COMPILER_VERSION}")
endif()

add_library(otreeobjs
	OBJECT
	util.c 
	tree_util.c 
	load_data.c perturb.c
	compute_impurity.c 
	impurity_measures.c 
	classify.c 
	prune.c)

add_library(otreestatic
	STATIC
	$<TARGET_OBJECTS:otreeobjs>)

# Data generation
add_executable(generate_data gendata.c)
target_link_libraries(generate_data otreestatic)

# Tree construction
add_executable(make_tree mktree.c)
target_link_libraries(make_tree otreestatic)

# Display
add_executable(display display.c)
target_link_libraries(display otreestatic)
