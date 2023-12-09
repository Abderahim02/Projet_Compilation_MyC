// PCode Header
#include "PCode.h"

int main() {
pcode_main();
return stack[sp-1].int_value;
}

void pcode_main() {
// Declare x of type int with offset 1 at depth 1
LOADI(0)

LOADI(3)
STOREP(bp + 1) // storing x value in current block
SAVEBP // entering block
// Declare x of type int with offset 1 at depth 2
LOADI(0)

LOADI(4)
STOREP(bp + 1) // storing x value in current block
SAVEBP // entering block
// Declare x of type int with offset 1 at depth 3
LOADI(0)

LOADI(5)
STOREP(bp + 1) // storing x value in current block
// Removing variable x at depth 3
RESTOREBP // exiting block
// Removing variable x at depth 2
RESTOREBP // exiting block
LOADI(1)
return;
}