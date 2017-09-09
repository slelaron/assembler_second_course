#include <bits/stdc++.h>

using namespace std;

void my_memcpy(void* dest, const void* source, size_t size);

char tmp[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'm', 'n', 'e', 'q', 'w', 't', 'r'};
char e[20];

int a[129];
int b[200];

int main()
{
	FILE* output = freopen("output", "w", stdout);
	
	for (int i = 0; i < 129; i++)
	{
		a[i] = i;
	}
	cout << sizeof(a) << ' ' << (long long)a << ' ' << (long long)a + sizeof(a) << endl;
	for (int i = 0; i < 129; i++)
	{
		cout << (int)b[i] << ' ';
	}
	cout << endl;
	my_memcpy(b + 1, a + 2, sizeof(a) - 8);
	for (int i = 0; i < 129; i++)
	{
		cout << (int)b[i] << ' ';
	}
	cout << endl;

	fclose(output);
	return 0;
}
