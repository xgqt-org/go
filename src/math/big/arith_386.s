// Copyright 2025 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Code generated by 'go generate' (with ./internal/asmgen). DO NOT EDIT.

//go:build !math_big_pure_go

#include "textflag.h"

// func addVV(z, x, y []Word) (c Word)
TEXT ·addVV(SB), NOSPLIT, $0
	MOVL z_len+4(FP), BX
	MOVL x_base+12(FP), SI
	MOVL y_base+24(FP), DI
	MOVL z_base+0(FP), BP
	// compute unrolled loop lengths
	MOVL BX, CX
	ANDL $3, CX
	SHRL $2, BX
	MOVL $0, DX	// clear saved carry
loop1:
	TESTL CX, CX; JZ loop1done
loop1cont:
	// unroll 1X in batches of 1
	ADDL DX, DX	// restore carry
	MOVL 0(SI), DX
	ADCL 0(DI), DX
	MOVL DX, 0(BP)
	SBBL DX, DX	// save carry
	LEAL 4(SI), SI	// ADD $4, SI
	LEAL 4(DI), DI	// ADD $4, DI
	LEAL 4(BP), BP	// ADD $4, BP
	SUBL $1, CX; JNZ loop1cont
loop1done:
loop4:
	TESTL BX, BX; JZ loop4done
loop4cont:
	// unroll 4X in batches of 1
	ADDL DX, DX	// restore carry
	MOVL 0(SI), CX
	ADCL 0(DI), CX
	MOVL CX, 0(BP)
	MOVL 4(SI), CX
	ADCL 4(DI), CX
	MOVL CX, 4(BP)
	MOVL 8(SI), CX
	ADCL 8(DI), CX
	MOVL CX, 8(BP)
	MOVL 12(SI), CX
	ADCL 12(DI), CX
	MOVL CX, 12(BP)
	SBBL DX, DX	// save carry
	LEAL 16(SI), SI	// ADD $16, SI
	LEAL 16(DI), DI	// ADD $16, DI
	LEAL 16(BP), BP	// ADD $16, BP
	SUBL $1, BX; JNZ loop4cont
loop4done:
	NEGL DX	// convert add carry
	MOVL DX, c+36(FP)
	RET

// func subVV(z, x, y []Word) (c Word)
TEXT ·subVV(SB), NOSPLIT, $0
	MOVL z_len+4(FP), BX
	MOVL x_base+12(FP), SI
	MOVL y_base+24(FP), DI
	MOVL z_base+0(FP), BP
	// compute unrolled loop lengths
	MOVL BX, CX
	ANDL $3, CX
	SHRL $2, BX
	MOVL $0, DX	// clear saved carry
loop1:
	TESTL CX, CX; JZ loop1done
loop1cont:
	// unroll 1X in batches of 1
	ADDL DX, DX	// restore carry
	MOVL 0(SI), DX
	SBBL 0(DI), DX
	MOVL DX, 0(BP)
	SBBL DX, DX	// save carry
	LEAL 4(SI), SI	// ADD $4, SI
	LEAL 4(DI), DI	// ADD $4, DI
	LEAL 4(BP), BP	// ADD $4, BP
	SUBL $1, CX; JNZ loop1cont
loop1done:
loop4:
	TESTL BX, BX; JZ loop4done
loop4cont:
	// unroll 4X in batches of 1
	ADDL DX, DX	// restore carry
	MOVL 0(SI), CX
	SBBL 0(DI), CX
	MOVL CX, 0(BP)
	MOVL 4(SI), CX
	SBBL 4(DI), CX
	MOVL CX, 4(BP)
	MOVL 8(SI), CX
	SBBL 8(DI), CX
	MOVL CX, 8(BP)
	MOVL 12(SI), CX
	SBBL 12(DI), CX
	MOVL CX, 12(BP)
	SBBL DX, DX	// save carry
	LEAL 16(SI), SI	// ADD $16, SI
	LEAL 16(DI), DI	// ADD $16, DI
	LEAL 16(BP), BP	// ADD $16, BP
	SUBL $1, BX; JNZ loop4cont
loop4done:
	NEGL DX	// convert sub carry
	MOVL DX, c+36(FP)
	RET

// func lshVU(z, x []Word, s uint) (c Word)
TEXT ·lshVU(SB), NOSPLIT, $0
	MOVL z_len+4(FP), BX
	TESTL BX, BX; JZ ret0
	MOVL s+24(FP), CX
	MOVL x_base+12(FP), SI
	MOVL z_base+0(FP), DI
	// run loop backward, using counter as positive index
	// shift first word into carry
	MOVL -4(SI)(BX*4), BP
	MOVL $0, DX
	SHLL CX, BP, DX
	MOVL DX, c+28(FP)
	// shift remaining words
	SUBL $1, BX
loop1:
	TESTL BX, BX; JZ loop1done
loop1cont:
	// unroll 1X in batches of 1
	MOVL -4(SI)(BX*4), DX
	SHLL CX, DX, BP
	MOVL BP, 0(DI)(BX*4)
	MOVL DX, BP
	SUBL $1, BX; JNZ loop1cont
loop1done:
	// store final shifted bits
	SHLL CX, BP
	MOVL BP, 0(DI)(BX*4)
	RET
ret0:
	MOVL $0, c+28(FP)
	RET

// func rshVU(z, x []Word, s uint) (c Word)
TEXT ·rshVU(SB), NOSPLIT, $0
	MOVL z_len+4(FP), BX
	TESTL BX, BX; JZ ret0
	MOVL s+24(FP), CX
	MOVL x_base+12(FP), SI
	MOVL z_base+0(FP), DI
	// use counter as negative index
	LEAL (SI)(BX*4), SI
	LEAL (DI)(BX*4), DI
	NEGL BX
	// shift first word into carry
	MOVL 0(SI)(BX*4), BP
	MOVL $0, DX
	SHRL CX, BP, DX
	MOVL DX, c+28(FP)
	// shift remaining words
	ADDL $1, BX
loop1:
	TESTL BX, BX; JZ loop1done
loop1cont:
	// unroll 1X in batches of 1
	MOVL 0(SI)(BX*4), DX
	SHRL CX, DX, BP
	MOVL BP, -4(DI)(BX*4)
	MOVL DX, BP
	ADDL $1, BX; JNZ loop1cont
loop1done:
	// store final shifted bits
	SHRL CX, BP
	MOVL BP, -4(DI)(BX*4)
	RET
ret0:
	MOVL $0, c+28(FP)
	RET

// func mulAddVWW(z, x []Word, m, a Word) (c Word)
TEXT ·mulAddVWW(SB), NOSPLIT, $0
	MOVL m+24(FP), BX
	MOVL a+28(FP), SI
	MOVL z_len+4(FP), DI
	MOVL x_base+12(FP), BP
	MOVL z_base+0(FP), CX
	// use counter as negative index
	LEAL (BP)(DI*4), BP
	LEAL (CX)(DI*4), CX
	NEGL DI
loop1:
	TESTL DI, DI; JZ loop1done
loop1cont:
	// unroll 1X in batches of 1
	MOVL 0(BP)(DI*4), AX
	// multiply
	MULL BX
	ADDL SI, AX
	MOVL DX, SI
	ADCL $0, SI
	MOVL AX, 0(CX)(DI*4)
	ADDL $1, DI; JNZ loop1cont
loop1done:
	MOVL SI, c+32(FP)
	RET

// func addMulVVWW(z, x, y []Word, m, a Word) (c Word)
TEXT ·addMulVVWW(SB), NOSPLIT, $0
	MOVL a+40(FP), BX
	MOVL z_len+4(FP), SI
	MOVL x_base+12(FP), DI
	MOVL y_base+24(FP), BP
	MOVL z_base+0(FP), CX
	// use counter as negative index
	LEAL (DI)(SI*4), DI
	LEAL (BP)(SI*4), BP
	LEAL (CX)(SI*4), CX
	NEGL SI
loop1:
	TESTL SI, SI; JZ loop1done
loop1cont:
	// unroll 1X in batches of 1
	MOVL 0(BP)(SI*4), AX
	// multiply
	MULL m+36(FP)
	ADDL BX, AX
	MOVL DX, BX
	ADCL $0, BX
	// add
	ADDL 0(DI)(SI*4), AX
	ADCL $0, BX
	MOVL AX, 0(CX)(SI*4)
	ADDL $1, SI; JNZ loop1cont
loop1done:
	MOVL BX, c+44(FP)
	RET
