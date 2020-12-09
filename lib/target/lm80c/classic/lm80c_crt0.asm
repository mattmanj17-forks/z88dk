;
;	Startup for LM80-C
;

	module	lm80c_crt0 


;--------
; Include zcc_opt.def to find out some info
;--------

        defc    crt0 = 1
        INCLUDE "zcc_opt.def"

;--------
; Some scope definitions
;--------

        EXTERN    _main           ;main() is always external to crt0 code

        PUBLIC    cleanup         ;jp'd to by exit()
        PUBLIC    l_dcal          ;jp(hl)

	defc	CONSOLE_COLUMNS = 32
	defc	CONSOLE_ROWS = 24


        defc    TAR__no_ansifont = 1
	defc	CRT_KEY_DEL = 12
	defc	__CPU_CLOCK = 3500000

        PUBLIC  PSG_AY_REG
        PUBLIC  PSG_AY_DATA
        defc    PSG_AY_REG = @01000000
        defc    PSG_AY_DATA = @01000001

        EXTERN    nmi_vectors
        EXTERN    asm_interrupt_handler
        EXTERN    __vdp_enable_status
        EXTERN    VDP_STATUS

        defc    TAR__clib_exit_stack_size = 0
        defc    TAR__register_sp = -1
        defc    TAR__fputc_cons_generic = 1

        INCLUDE "target/lm80c/def/lm80c.def"
        INCLUDE "target/lm80c/def/maths_mbf.def"

	defc CRT_ORG_CODE = 0x8241

        INCLUDE "crt/classic/crt_rules.inc"

   	org CRT_ORG_CODE

	; BASIC header for the LM80-C
basicstart:   
        defb 0x51, 0x82, 0xe4, 0x07, 0xab, 0x26, 0x48, 0x38
        defb 0x32, 0x35, 0x33, 0x3a, 0x80, 0x20, 0x20, 0x00
        defb 0x00, 0x00
   
start:
	ld	(start1+1),sp
        INCLUDE "crt/classic/crt_init_sp.asm"
        INCLUDE "crt/classic/crt_init_atexit.asm"
	call	crt0_init_bss
	ld	(exitsp),sp

; Optional definition for auto MALLOC init
; it assumes we have free space between the end of 
; the compiled program and the stack pointer
	IF DEFINED_USING_amalloc
		INCLUDE "crt/classic/crt_init_amalloc.asm"
	ENDIF


	; Setup NMI if required
	ld	hl,interrupt
	ld	(NMIUSR+1),hl
	ld	a,195	;JP
	ld	(NMIUSR),a

        call    _main
cleanup:
;
;       Deallocate memory which has been allocated here!
;
        push    hl
        call    crt0_exit

	; We should probably disable VDP interrupts before doing this
	ld	hl,$45ED	;retn
	ld	(NMIUSR),hl

        pop     bc
start1:
        ld      sp,0
	ret

l_dcal:
        jp      (hl)

; VDP interrupt
        EXTERN    __vdp_enable_status
        EXTERN    VDP_STATUS
interrupt:
        push    af
        push    hl
        ld      a,(__vdp_enable_status)
        rlca
        jr      c,no_vbl
        in      a,(VDP_STATUS)
no_vbl:
        ld      hl,nmi_vectors
        call    asm_interrupt_handler
        pop     hl
        pop     af
        retn


	INCLUDE "crt/classic/crt_runtime_selection.asm" 
	
	INCLUDE	"crt/classic/crt_section.asm"
