# C to Pseudocode Translator
This project is a C to pseudocode translator designed to convert simple C programs into pseudocode representations. The translator aims to assist programmers in understanding and analyzing C code by providing a more structured and readable format.

Features:
Function Recognition: The translator identifies functions within the input C code and converts them into pseudocode format. It handles function headers, parameters, and bodies appropriately.

Function Calls: Function calls, including standard library functions like printf and scanf, are recognized and translated into pseudocode. User-defined function calls are also supported.

Return Statements: Return statements within functions are translated into pseudocode format. The translator assigns returned values to the corresponding function names.

Loop Handling: C for loops are recognized and converted into pseudocode representations. Assignment, comparison, and increment sections of the loops are appropriately translated.

Conditional Statements: If-else conditions are supported in the translation process. The translator converts conditions and nested conditions into pseudocode format.

Usage:
Clone the project repository from GitHub to your local machine.
Ensure you have a C file ready for translation.
Run the translator program and provide the path to the C file as input.
The translator will generate the pseudocode representation of the C code and display it either on the console or in an output file.
Example:
Consider the following C code:

```bash
#include <stdio.h>

int main() {
    int x = 10;
    if (x > 5) {
        printf("x is greater than 5\n");
    }
    return 0;
}```

The translator will convert it into pseudocode as follows:

```bash
FUNCTION main
x = 10
IF x > 5 THEN
    PRINT "x is greater than 5"
ENDIF
RETURN 0
END FUNCTION main
```
Contributing:
Contributions to the project are welcome. If you encounter any bugs or have suggestions for improvements, please open an issue on the GitHub repository.
