// Header
#include "PCode.h"
int main() {
pcode_main();
return stack[sp-1].int_value;
}

void pcode_main() {
LOADF(1.000000)
LOADF(2.200000)
LOADF(3.500000)
MULTF
ADDF
return;
}
Error: empty program

