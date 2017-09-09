#include <bits/stdc++.h>

using namespace std;

void my_memcpy(void* dest, const void* source, size_t size);

const int maxN = 1000;
const int maxT = 3e7 + 9;

char a[maxN];
char b[2 * maxN];
char c[2 * maxN];

char d[maxT];
char k[maxT];
char t[maxT];
char v[maxT];

int main()
{
	for (int i = 0; i < maxN; i++)
	{
		a[i] = rand() % 256 - 128;
	}
	for (int i = 0; i < 1000; i++)
	{
		for (int j = 0; j < 2 * maxN; j++)
		{
			b[j] = 0;
			c[j] = 0;
		}
		int aa = rand() % maxN;
		int bb = rand() % maxN;
		int fst = min(aa, bb);
		int dist = abs(aa - bb);
		int snd = rand() % maxN;
		my_memcpy(b + snd, a + fst, dist);
		memcpy(c + snd, a + fst, dist);
		bool flag = true;
		for (int j = 0; j < 2 * maxN; j++)
		{
			if (c[j] != b[j])
			{
				flag = false;
				break;
			}
		}
		if (flag)
		{
			cout << "OK" << endl;
		}
		else
		{
			cout << "Fail " << snd << ' ' << fst << ' ' << dist << endl;
			for (int j = 0; j < maxN; j++)
			{
				cout << (int)a[j] << ' ';
			}
			cout << endl;
			for (int j = 0; j < 2 * maxN; j++)
			{
				cout << "(" << (int)b[j] << ", " << (int)c[j] << ") ";
			}
			cout << endl;
			break;
		}
	}

	for (int j = 0; j < maxT; j++)
	{
		d[j] = rand() % 256 - 128;
	}

	int now = clock();
	for (int j = 0; j < 100; j++)
	{
		my_memcpy(k + 1, d + 2, sizeof(d) - 3);
	}
	int have = clock();
	cout << (double)(have - now) / CLOCKS_PER_SEC << endl;
	
	now = clock();
	for (int j = 0; j < 100; j++)
	{
		memcpy(t + 1, d + 2, sizeof(d) - 3);
	}
	have = clock();
	cout << (double)(have - now) / CLOCKS_PER_SEC << endl;

	now = clock();
	for (int j = 0; j < 100; j++)
	{
		int a = 1;
		int b = 2;
		for (size_t i = 0; i < sizeof(d) - 3; i++)
		{
			v[i + a] = d[i + b];
		}
	}
	have = clock();
	cout << (double)(have - now) / CLOCKS_PER_SEC << endl;
	
	bool correct = true;
	for (int i = 0; i < maxT; i++)
	{
		if (k[i] != t[i])
		{
			correct = false;
		}
	}
	if (correct)
	{
		cout << "last is OK" << endl;
	}
	else
	{
		cout << "last Failed" << endl;
	}
	
	return 0;
}
