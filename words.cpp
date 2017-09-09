#include <bits/stdc++.h>

using namespace std;

extern "C" int count_words_internal(char* tmp, size_t);

int count_words(char* a, size_t len)
{
	if (len <= 16)
	{
		bool previous = false;
		int count = 0;
		for (size_t i = 0; i < len; i++)
		{
			if (a[i] != ' ' && !previous)
			{
				previous = true;
				count++;
			}
			if (a[i] == ' ')
			{
				previous = false;
			}
		}
		return count;
	}
	else
	{
		return count_words_internal(a, len);
	}
}
