#include <map>
#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>

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
	std::stringstream ss;
	std::ifstream file;
	file.open("in/day_15.txt");
	ss << file.rdbuf();
	file.close();
	std::vector<long long> input;
	for (int n; ss >> n;) {
		input.push_back(n);
		if (ss.peek() == ',') {
			ss.ignore();
		}
	}
	long long elem_2020 = nth_memory_element(2020, input);
	std::cout << "the 2020th element in the sequence" << std::endl << elem_2020 << std::endl;
	long long elem_30mil = nth_memory_element(30000000, input);
	std::cout << std::endl << "the 30 millionth element in the sequence" << std::endl << elem_30mil << std::endl;
	return 0;
}
