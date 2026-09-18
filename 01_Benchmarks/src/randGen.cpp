#include <iostream>
#include <set>
#include <random>
#include <fstream>
#include <cmath>
#include <string>

int main() {
    int N = 10; //ten million Total number of unique numbers to generate
    std::set<double> numbers;

    // Initialize a random number generator
    std::random_device rd;
    std::mt19937 gen(rd());
    int range = 100000000;//hundred million
    std::uniform_int_distribution<> dis(1, range); // Adjust the range as needed

    // Generate unique random numbers
    while (numbers.size() < N) {
        numbers.insert(dis(gen));
    }

    // Open the file for writing
    std::string fname =  std::to_string(N) + "_numbers.csv";
    std::ofstream writeFile(fname);
    if (!writeFile.is_open()) {
        std::cerr << "Unable to open file for writing." << std::endl;
        return 1; // Return an error code
    }

    // Write the numbers to the file in ascending order
    for (int num : numbers) {
        writeFile << num << "\n";
    }

    // Close the file
    writeFile.close();

    std::cout << "Numbers written to _numbers.csv successfully." << std::endl;

    return 0;
}
