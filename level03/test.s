	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 10, 15	sdk_version 10, 15, 6
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset %ebp, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register %ebp
	pushl	%edi
	pushl	%esi
	subl	$16, %esp
	.cfi_offset %esi, -16
	.cfi_offset %edi, -12
	calll	L0$pb
L0$pb:
	popl	%eax
	movl	12(%ebp), %ecx
	movl	8(%ebp), %edx
	movl	$0, -12(%ebp)
	movl	12(%ebp), %esi
	movl	8(%esi), %esi
	movl	12(%ebp), %edi
	movl	4(%edi), %edi
	subl	%edi, %esi
	cmpl	$21, %esi
	movl	%eax, -16(%ebp)         ## 4-byte Spill
	jle	LBB0_2
## %bb.1:
	movl	-16(%ebp), %eax         ## 4-byte Reload
	leal	L_.str-L0$pb(%eax), %ecx
	movl	%ecx, (%esp)
	calll	_printf
	jmp	LBB0_3
LBB0_2:
	movl	-16(%ebp), %eax         ## 4-byte Reload
	leal	L_.str.1-L0$pb(%eax), %ecx
	movl	%ecx, (%esp)
	calll	_printf
LBB0_3:
	xorl	%eax, %eax
	addl	$16, %esp
	popl	%esi
	popl	%edi
	popl	%ebp
	retl
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"Good job bro\n"

L_.str.1:                               ## @.str.1
	.asciz	"Try again bro\n"

.subsections_via_symbols
