nasm -f elf64 memcpy_func.nasm
g++-7 -std=gnu++17 -O2 -Wall -c Test.cpp
g++-7 -std=gnu++17 -O2 -Wall -c my_memcpy.cpp
g++-7 -std=gnu++17 -O2 Test.o memcpy_func.o my_memcpy.o -o Test
