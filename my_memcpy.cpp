#include <bits/stdc++.h>

using namespace std;

extern "C" void memcpy_func(void* dest, const void* source, size_t size);

void my_memcpy(void* dest, const void* source, size_t size)
{
	if (size <= 32)
	{
		char* _dest = reinterpret_cast<char*>(dest);
		const char* _source = reinterpret_cast<const char*>(source);
		for (size_t i = 0; i < size; i++)
		{
			_dest[i] = _source[i];
		}
	}
	else
	{
		memcpy_func(dest, source, size);
	}
}
