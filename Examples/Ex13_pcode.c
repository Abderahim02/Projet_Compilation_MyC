// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}
void pcode_main() {
LOADI(0)
LOADI(0)
LOADI(3)
STOREP(bp + 1) // storing x value in current block
SAVEBP // entering block
LOADI(0)
LOADI(4)
STOREP(bp + 1) // storing x value in current block
SAVEBP // entering block
LOADI(0)
LOADI(5)
STOREP(bp + 1) // storing x value in current block
RESTOREBP // exiting block
LOADP(bp+1) // Loading x value in curent block
STOREP(stack[bp] + 2) // storing y value one block above
RESTOREBP // exiting block
LOADP(bp+1) // Loading x value in curent block
STOREP(bp + 2) // storing y value in current block
LOADP(bp+2) // Loading y value in curent block
return;
}