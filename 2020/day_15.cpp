#include <map>
#include <iostream>
#include <vector>

long long nth_memory_element(long long n, std::vector<long long> initial) {
	std::map<long long, long long> seen;
	long long initial_n = initial.size();
	for (long long i = 0; i < initial_n - 1; i += 1) {
		seen[initial[i]] = i;
	}
	long long key = initial[initial_n - 1];
	for (long long i = initial_n - 1; i < n - 1; i += 1) {
		long long next_key;
		if (seen.count(key) == 1) {
			next_key = i - seen[key];
		} else {
			next_key = 0;
		}
		seen[key] = i;
		key = next_key;
	}
	return key;
}

int main() {
	std::cout << nth_memory_element(2020, { 5, 2, 8, 16, 18, 0, 1 }) << std::endl;
	return 0;
}
