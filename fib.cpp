#include <iostream>

using namespace std;

void printFibonacci(int n) {
    unsigned long long a = 1, b = 1;
    if (n >= 1) cout << a << " ";
    if (n >= 2) cout << b << " ";

    for (int i = 3; i <= n; ++i) {
        unsigned long long c = a + b;
        cout << c << " ";
        a = b;
        b = c;
    }
}

int main() {
    int n;
    cin >> n;
    if (n <= 0) {
        cout << "Error: Enter a positive integer" << endl;
        return 1;
    }
    printFibonacci(n);
    cout << endl;
    return 0;
}
