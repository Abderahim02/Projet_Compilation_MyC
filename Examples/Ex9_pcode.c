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
LOADI(0)
STOREP(2) // storing z value
StartLoop_0: // chargement condition boucle while 0
LOADP(0) // Loading x value
LOADI(0)
GTI
IFN(EndLoop_0)
SAVEBP // entering block
LOADP(2) // Loading z value
LOADP(1) // Loading y value
ADDI
STOREP(2) // storing z value
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