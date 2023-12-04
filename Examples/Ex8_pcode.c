
// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}

LOADF(0.0)
LOADF(0.0)
LOADI(0)
void pcode_main() {
LOADP(0) // Loading x value
LOADF(0.000000)
GTF
IFN(False_0)
SAVEBP // entering block
LOADP(1) // Loading y value
LOADF(0.000000)
GTF
IFN(False_1)
LOADI(1)
STOREP(2) // storing z value
GOTO(End_1)
False_1:
LOADI(2)
STOREP(2) // storing z value
End_1:
RESTOREBP // exiting block
GOTO(End_0)
False_0:
SAVEBP // entering block
LOADP(1) // Loading y value
LOADF(0.000000)
GTF
IFN(False_2)
LOADI(3)
STOREP(2) // storing z value
GOTO(End_2)
False_2:
LOADI(4)
STOREP(2) // storing z value
End_2:
RESTOREBP // exiting block
End_0:
LOADP(2) // Loading z value
return;
}