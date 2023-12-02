// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return srack[sp-1].int_value;
}

LOADI(0)
LOADI(0)
LOADI(0)
void pcode_main() {
LOADI(3)
STOREP(0) // storing x value
LOADI(5)
STOREP(1) // storing y value
LOADP(1) // Loading y value
STOREP(2) // storing z value
StartLoop_0: // chargement condition boucle while 0
LOADP(0) // Loading x value
LOADI(0)
GTI
IFN(EndLoop_0)
SAVEBP // entering block
StartLoop_1: // chargement condition boucle while 1
LOADP(1) // Loading y value
LOADI(0)
GTI
IFN(EndLoop_1)
SAVEBP // entering block
LOADP(1) // Loading y value
LOADI(1)
SUBI
STOREP(1) // storing y value
LOADP(2) // Loading z value
LOADI(1)
ADDI
STOREP(2) // storing z value
RESTOREBP // exiting block
GOTO(StartLoop_1)
EndLoop_1:
LOADP(2) // Loading z value
STOREP(1) // storing y value
LOADP(0) // Loading x value
LOADI(1)
SUBI
STOREP(0) // storing x value
RESTOREBP // exiting block
GOTO(StartLoop_0)
EndLoop_0:
LOADP(2) // Loading z value
return;
}