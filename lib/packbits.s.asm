;
; unpkb.asm
; PackBits RLE unpacking
;
;
; Copyright 2000 Damian Yerrick
; 
; Permission is hereby granted, free of charge, to any person obtaining
; a copy of this software and associated documentation files (the
; "Software"), to deal in the Software without restriction, including
; without limitation the rights to use, copy, modify, merge, publish,
; distribute, sublicense, and/or sell copies of the Software, and to
; permit persons to whom the Software is furnished to do so, subject to
; the following conditions:
; 
; The above copyright notice and this permission notice shall be
; included in all copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
; OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
; AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
; OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
; IN THE SOFTWARE.
; 

;
; PKB_unpackblk
; Unpack PackBits() encoded data from memory at (PKB_source)
; to a character device such as the NES PPU data register.
;
; This entry point assumes a 16-bit length word in network
; byte order before the data.
.PKB_unpackblk
                ldy #0
                lda (PKB_source),y
                inc PKB_source
                bne l1
                inc PKB_source+1
.l1
                sta PKB_len+1
                lda (PKB_source),y
                inc PKB_source
                bne l2
                inc PKB_source+1
.l2
                sta PKB_len

; This entry point assumes a 16-bit length word in host byte order
; at PKB_len.
.PKB_unpack
                lda PKB_len
                beq l3
                inc PKB_len+1   ;trick to allow easier 16-bit decrement
.l3
                ldy #0
.PKB_loop
                lda (PKB_source),y
                bmi PKB_run

                                ;got a string
                inc PKB_source
                bne l4
                inc PKB_source+1
.l4
                tax
                inx
                txa
.l7
                lda (PKB_source),y
                inc PKB_source
                bne l5
                inc PKB_source+1
.l5
                sta (PKB_dest),y
                inc PKB_dest
		        bne skip1
        		inc PKB_dest+1
.skip1
                dec PKB_len
                bne l6
                dec PKB_len+1
                beq PKB_rts
.l6
                dex
                bne l7
                beq PKB_loop

.PKB_run                         ;got a run
                inc PKB_source
                bne l8
                inc PKB_source+1
.l8
                tax
                dex
                lda (PKB_source),y
                inc PKB_source
                bne l9
                inc PKB_source+1
.l9
.l11
                sta (PKB_dest),y
                inc PKB_dest
		        bne skip2
        		inc PKB_dest+1
.skip2
                dec PKB_len
                bne l10
                dec PKB_len+1
                beq PKB_rts
.l10
                inx
                bne l11
                beq PKB_loop
.PKB_rts
                rts
