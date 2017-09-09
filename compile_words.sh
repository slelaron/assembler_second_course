nasm -f elf64 Number_of_words_in_text.nasm
g++-7 -std=gnu++17 -O2 -Wall -c Test_words.cpp
g++-7 -std=gnu++17 -O2 -Wall -c words.cpp
g++-7 -std=gnu++17 -O2 Test_words.o words.o Number_of_words_in_text.o -o words_count
