; sccz80 crt0 library - 8085 version

SECTION code_crt0_sccz80
PUBLIC  l_asr
PUBLIC  l_asr_hl_by_e

.l_asr
    ex de,hl
.l_asr_hl_by_e
.l_asr1
    dec e
    ret m

    sra hl
    jp l_asr1