#include <bits/stdc++.h>
#include <type_traits>

using namespace std;

int count_words(char* tmp, size_t);

const int maxN = 300;

char text[maxN];

int get_answer(int fst, size_t dist)
{
	bool prev = true;
	int answer = 0;
	for (size_t i = 0; i < dist; i++)
	{
		bool now;
		if (text[fst + i] == ' ')
		{
			now = true;
		}
		else
		{
			now = false;
		}
		if (now != prev && prev)
		{
			answer++;
		}
		prev = now;
	}
	return answer;
}

int main()
{
	for (int i = 0; i < maxN; i++)
	{
		int now = rand();
		if (now % 2 == 0)
		{
			text[i] = ' ';
		}
		else
		{
			text[i] = 'a';
		}
	}
	/*for (int test = 0; test < 20; test++)
	{
		int a = rand() % maxN;
		int b = rand() % maxN;
		int fst = min(a, b);
		size_t dist = (size_t)abs(a - b);
		int answer = get_answer(fst, dist);
		int cnt = count_words(text + fst, dist);
		if (cnt == answer)
		{
			cout << "Ok " << cnt << ' ' << answer << endl;
		}
		else
		{
			cout << "Failed " << cnt << ' ' << answer << endl;
			cout << fst << ' ' << dist << endl;
			for (int i = fst; i < (int)(fst + dist); i++)
			{
				if (text[i] == ' ')
				{
					cout << '_' << ' ';
				}
				else
				{
					cout << 'a' << ' ';
				}
			}
			cout << endl;
			break;
		}
	}*/
	cout << count_words(text + 190, 25) << ' ' << get_answer(190, 25) << endl;
	return 0;
}
