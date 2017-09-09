#include <bits/stdc++.h>
#include <type_traits>

using namespace std;

int count_words(char* tmp, size_t);

char text[] = "In computing, Streaming SIMD Extensions (SSE) is an SIMD instruction set extension to the x86 architecture, designed by Intel and introduced in 1999 in their Pentium III series of processors shortly after the appearance of AMD's 3DNow!. SSE contains 70 new instructions, most of which work on single precision floating point data. SIMD instructions can greatly increase performance when exactly the same operations are to be performed on multiple data objects. Typical applications are digital signal processing and graphics processing.";
		    //" anssi. C++ International Standard   (second  edition,   2003-10-15)  a  "
			//"100000110011000000000000110000000100100000010100000001001000000000010110
char that[4000];


int main()
{
	int sz = 0;
	for (char* a = text + 1; (long long)a % 16 != 0; a++, sz++);
	cout << sizeof(text) - 1 << endl;
	int cnt = count_words(text, sizeof(text));
	//cout << bitset<64>(cnt) << endl;
	cout << cnt << endl;
	long long another = 0;
	for (int i = 0; i < 8; i++)
	{
		another <<= 8;
		another ^= text[i];
	}
	cout << std::bitset<64>(another);
	for (int i = 0; i < 8; i++)
	{
		another <<= 8;
		another ^= text[8 + i];
	}
	cout << std::bitset<64>(another) << endl;
	long long here = 0;
	for (int i = 0; i < 8; i++)
	{
		here <<= 8;
		here ^= that[i];
	}
	cout << std::bitset<64>(here) << endl;
	/*here = 0;
	for (int i = 0; i < 8; i++)
	{
		here <<= 8;
		here ^= that[8 + i];
	}
	cout << std::bitset<64>(here) << endl;*/
	return 0;
}
