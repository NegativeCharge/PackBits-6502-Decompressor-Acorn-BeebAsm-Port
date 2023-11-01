LOAD_ADDR = &5800

\ Allocate vars in ZP
ORG &80
GUARD &9F
.zp_start
    INCLUDE ".\lib\packbits.h.asm"
.zp_end

\ Main
CLEAR 0, LOAD_ADDR
GUARD LOAD_ADDR
ORG &1100
.start
    INCLUDE ".\lib\packbits.s.asm"

.entry_point

    \\ Turn off cursor by directly poking crtc
    lda #&0b
    sta &fe00
    lda #&20
    sta &fe01

    lda #<comp_data
    sta PKB_source+0
    lda #>comp_data
    sta PKB_source+1

    lda #<LOAD_ADDR
    sta PKB_dest+0
    lda #>LOAD_ADDR
    sta PKB_dest+1

    jsr PKB_unpackblk
    
    jmp *
    
.comp_data
    INCBIN ".\tests\test_0.bin.pkb"

.end

SAVE "PACKBTS", start, end, entry_point

\ ******************************************************************
\ *	Memory Info
\ ******************************************************************

PRINT "------------------------"
PRINT " Packbits Decompressor  "
PRINT "------------------------"
PRINT "CODE SIZE         = ", ~end-start
PRINT "DECOMPRESSOR SIZE = ", entry_point-start, "bytes"
PRINT "ZERO PAGE SIZE    = ", zp_end-zp_start, "bytes"
PRINT "------------------------"
PRINT "LOAD ADDR      = ", ~start
PRINT "HIGH WATERMARK = ", ~P%
PRINT "RAM BYTES FREE = ", ~LOAD_ADDR-P%
PRINT "------------------------"

PUTBASIC "loader.bas","LOADER"
PUTFILE  "BOOT","!BOOT", &FFFF  