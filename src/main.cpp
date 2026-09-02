#include <iostream>
#include <string>
#include <string_view>

using namespace std;

int main(int argc, char *argv[]) {
    for (int i = 1; i < argc; i++) {
        if (string_view(argv[i]) == "--help" || string_view(argv[i]) == "-h") {
            cout << "Usage Placeholder" << endl;
            return 0;
        }
    }
    return 1;
}