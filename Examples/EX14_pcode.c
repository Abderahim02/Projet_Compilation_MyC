// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}

void pcode_plusUn() {
// Argument x of function plusUn in TDS with offset -1
LOADP(bp+-1) // Loading x value in curent block
LOADI(1)
ADDI
return;
}
void pcode_main() {
// loading function plusUn arguments
LOADI(1)
SAVEBP
CALL(pcode_plusUn)
RESTOREBP
ENDCALL(1) // unloading 1 args of function plusUn
return;
}