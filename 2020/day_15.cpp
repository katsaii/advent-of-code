#include <map>
#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>

using Number = long long;

Number nth_memory_element(Number n, std::vector<Number> initial) {
	std::map<Number, Number> seen;
	Number initial_n = initial.size();
	for (Number i = 0; i < initial_n - 1; i += 1) {
		seen[initial[i]] = i;
	}
	Number key = initial[initial_n - 1];
	for (Number i = initial_n - 1; i < n - 1; i += 1) {
		Number next_key;
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
	std::vector<Number> input;
	for (int n; ss >> n;) {
		input.push_back(n);
		if (ss.peek() == ',') {
			ss.ignore();
		}
	}
	Number elem_2020 = nth_memory_element(2020, input);
	std::cout << "the 2020th element in the sequence" << std::endl << elem_2020 << std::endl;
	Number elem_30mil = nth_memory_element(30000000, input);
	std::cout << std::endl << "the 30 millionth element in the sequence" << std::endl << elem_30mil << std::endl;
	return 0;
}
