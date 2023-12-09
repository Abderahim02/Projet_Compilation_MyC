// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}

void pcode_plus() {
// Argument y of function plus in TDS with offset -1
// Argument x of function plus in TDS with offset -2
LOADP(bp+-2) // Loading x value in curent block
LOADP(bp+-1) // Loading y value in curent block
ADDI
return;
}
void pcode_main() {
// loading function plus arguments
LOADI(5)
LOADI(6)
SAVEBP
CALL(pcode_plus)
RESTOREBP
ENDCALL(2) // unloading 2 args of function plus
return;
}