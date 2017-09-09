#include <bits/stdc++.h>

using namespace std;

int main()
{
	string s;
	cin >> s;
	int answer = 0;
	for (size_t i = 0; i < s.length(); i++)
	{
		if (s[i] == '1')
		{
			answer++;
		}
	}
	cout << answer;
	return 0;
}
