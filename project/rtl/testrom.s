lbafat1	equ	21h
lbafat2	equ	27h
lbadir	equ	2dh
lbadire	equ	3dh
lbafile	equ	4dh
MAXFAT	equ	2048

ata	equ	0e0h

; ********** Start up routine **********

	org	6000h
	;org	6800h

	defb	41h,42h
	;ld	bc,7c0h
	;ld	de,6840h
	;ld	hl,6040h
	;ldir
	;
	call	devsel
	ld	a,1
	out	(ata+1),a
	ld	a,0efh
	out	(ata+7),a	; enable 8bit mode
	;
	ld	hl,files
	ld	(0f14eh),hl
	ld	hl,load
	ld	(0f139h),hl
	ld	hl,kill
	ld	(0f142h),hl
	ld	hl,save
	ld	(0f14bh),hl
	ld	hl,0
	ld	(mstart),hl
	ld	(mend),hl
	ret

; ********** BASIC Command **********

	;org	6840h

files:
	ld	hl,lbadir
files4:
	push	hl
	call	readbuf
	ld	hl,buffer
	ld	b,10h
files3:	
	ld	a,(hl)
	or	a
	ld	de,32
	jr	z,files1
	ld	e,11
	push	hl
	add	hl,de
	bit	2,(hl)
	pop	hl
	ld	e,32
	jr	nz,files1
	push	bc
	ld	b,11
files2:
	ld	a,(hl)
	inc	hl
	call	257h
	djnz	files2
	pop	bc
	call	5fcah
	call	0cf1h
	jr	z,files5
	jr	c,files6
	call	0f75h
	cp	3
	jr	z,files6
files5:
	ld	e,21
files1:
	add	hl,de
	djnz	files3
	pop	hl
	inc	l
	ld	a,l
	cp	lbadire
	jr	nz,files4
	jp	81h
files6:
	ld	hl,filesmes
	call	52edh
	jp	81h
filesmes:
	defb	'^C',13,10,'Break',13,10,7,0

save:
	call	fopen
	jr	z,save1
	ld	hl,savemes1
	call	52edh
	call	0f75h
	cp	'y'
	jp	nz,81h
	call	killsub
save1:
	call	fopenw
	jp	z,44a5h	; directory entry full
	ld	hl,dirent
	ld	b,20h
	call	bzero
	ld	bc,11
	ld	de,dirent
	ld	hl,str
	push	de
	ldir
	ld	hl,0
	call	savefat
	ld	(fatnum),de
	pop	hl
	ld	bc,1ah
	add	hl,bc
	ld	(hl),e
	inc	hl
	ld	(hl),d
	;
	call	5b86h
	ld	hl,header
	ld	b,10h
	call	bzero
	ld	hl,(0efa0h)
	ld	de,(0eb54h)
	or	a
	sbc	hl,de
	ld	b,l
	ld	c,h
	ld	(header+2),bc
	ld	hl,(mstart)
	ld	b,l
	ld	c,h
	ld	(header+4),bc
	ex	de,hl
	ld	hl,(mend)
	or	a
	sbc	hl,de
	jr	z,save2	; don't write mstart=0,mend=0
	inc	hl
save2:
	ld	b,l
	ld	c,h
	ld	(header+6),bc
	ld	hl,header
	ld	bc,10h
	call	fwrite	; write header
	;
	ld	hl,(header+2)
	ld	b,l
	ld	c,h
	ld	hl,(0eb54h)
	call	fwrite	; write BASIC
	;
	ld	hl,header+6
	ld	b,(hl)
	inc	hl
	ld	c,(hl)
	ld	hl,(mstart)
	call	fwrite	; write ML
	ld	hl,(fileptr)
	ld	(dirent+1ch),hl
	;
	ld	hl,(lba)
	ld	de,buffer
	ld	a,1
	call	write	; write last buffer
	ld	hl,(fatnum)
	ld	bc,0ffffh
	scf
	call	nextfat	; terminate fat
	;
	ld	hl,(dirlba)
	call	readbuf
	ld	hl,dirent
	ld	de,(entry)
	ld	bc,20h
	ldir
	call	sync
	jp	81h
savemes1:
	defb	'Overwrite?[y/n]',0

kill:
	call	fopen
	jp	z,44a5h
	call	killsub
	call	sync
	jp	81h

killsub:
	ld	hl,(entry)
	ld	(hl),0
	ld	hl,(fatnum)
killsub1:
	scf
	ld	bc,0
	call	nextfat
	ld	hl,0fffh
	call	5ed3h
	ex	de,hl
	jr	nz,killsub1
	jp	81h

sync:
	ld	hl,(dirlba)
	ld	de,buffer
	ld	a,1
	call	write
	ld	hl,lbafat1
	ld	de,fat
	ld	a,lbafat2-lbafat1
	call	write
	ld	hl,lbafat2
	ld	de,fat
	ld	a,lbafat2-lbafat1
	jp	write

load:
	call	fopen
	jp	z,44a5h
	ld	bc,10h
	ld	hl,header
	call	fread	; load file header
	ld	hl,header+4
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	(mstart),de
	ld	b,(hl)
	inc	hl
	ld	c,(hl)
	ex	de,hl
	add	hl,bc
	jr	z,load2	;	for mstart=0,mend=0
	dec	hl
load2:
	ld	(mend),hl
	;
	ld	hl,header+2
	ld	b,(hl)
	inc	hl
	ld	c,(hl)
	ld	a,c
	or	b
	ld	hl,8021h
	call	nz,fread	; load BASIC
	ld	hl,header+4
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	c,(hl)
	ex	de,hl
	ld	a,c
	or	b
	call	nz,fread	; load ML
	ld	hl,header+2
	ld	a,(hl)
	inc	hl
	or	(hl)
	jr	z,load1
	call	3d76h
	inc	hl
	ld	(0efa0h),hl
	jp	1f8eh
load1:
	ld	hl,header
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	ld	a,e
	or	d
	jp	z,81h
	ex	de,hl
	jp	(hl)

; ********** Buffered I/O **********

; out Z  directory entry full
; use A,F,B,C,D,E,H,L

fopenw:
	ld	hl,strz
	jr	fopen0

; in  HL pointer
; out Z  error
; use A,F,B,C,D,E,H,L

fopen:
	ld	a,(hl)
	inc	hl
	cp	22h
	jp	nz,44a5h
	ld	b,11
	ld	de,str
fopen6:
	ld	a,(hl)
	inc	hl
	or	a
	jr	z,fopen5
	cp	22h
	jr	z,fopen5
	cp	61h
	jr	c,fopen8
	cp	7bh
	jr	nc,fopen8
	and	0dfh	; toupper
fopen8:
	ld	(de),a
	inc	de
	djnz	fopen6
	jr	fopen2
fopen5:
	ld	a,20h
fopen7:
	ld	(de),a
	inc	de
	djnz	fopen7
fopen2:
	ld	hl,strncmp
fopen0:
	ld	(fopena),hl
	ld	hl,lbadir
fopen1:
	push	hl
	call	readbuf
	ld	hl,buffer
	ld	b,10h
fopen3:	
	ld	de,str
	ld	a,11
	defb	0cdh
fopena:
	defb	0, 0
	jr	z,fopen4
	ld	de,20h
	add	hl,de
	djnz	fopen3
	pop	hl
	inc	l
	ld	a,l
	cp	lbadire
	jr	nz,fopen1
	ret
fopen4:
	ld	(entry),hl
	ld	bc,1ah
	add	hl,bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	(fatnum),de
	;
	ld	de,fat
	ld	hl,lbafat1
	ld	a,lbafat2-lbafat1
	call	read
	;
	ld	hl,0
	ld	(fileptr),hl
	pop	hl
	ld	(dirlba),hl
	xor	a
	inc	a
	ret

; in  BC byte count
;     HL transfer address

fread:
	ld	(memptr),hl
	ld	hl,read
	ld	(frwop4),hl
	ld	a,3ch
	ld	(frwop0),a
	ld	a,53h
	ld	(frwop2),a
	ld	a,frw1-frw11
	ld	(frwop6),a
	xor	a
	ld	(frwop5),a
	ld	(frwop1),a
	jr	frw
fwrite:
	ld	(memptr),hl
	ld	hl,write
	ld	(frwop4),hl
	ld	a,0a7h
	ld	(frwop0),a
	ld	a,0ebh
	ld	(frwop1),a
	ld	a,63h
	ld	(frwop2),a
	ld	a,frw10-frw9
	ld	(frwop5),a
	xor	a
	ld	(frwop6),a
	ld	a,frw5-frw7
frw:
	ld	(frwop3),a
	ld	a,c
	or	b
	ret	z
	ld	(count),bc
frw6:
	ld	hl,(fileptr)
	ld	a,h
	and	1
	or	l
	jr	nz,frw1	; halfway sector
	defb	18h
frwop5:
	defb	0	;@R none @W frw10
frw9:
	ld	a,h
	and	0eh
	jr	nz,frw2	; halfway cluster
	ld	hl,(fatnum)
	sla	l
	rl	h
	sla	l
	rl	h
	sla	l
	rl	h
	ld	de,lbafile-2*8
	add	hl,de
	ld	(lba),hl
frw10:
	ld	a,(fileptr+1)
frwop0:
	defb	0	;@R inc a @W or a
	jr	z,frw12
frw2:
	ld	hl,(lba)
	push	hl
	ld	de,buffer
	ld	a,1
	defb	0cdh
frwop4:
	defw	0	;@R read @W write
	pop	hl
	inc	hl
	ld	(lba),hl
	defb	18h
frwop6:
	defb	0	;@R frw1 @W none
frw11:
	ld	hl,(fileptr)
	ld	a,h
	and	0fh
	or	l
	jr	nz,frw1
	ld	hl,(fatnum)
	call	savefat
	ld	(fatnum),de
frw12:
	ld	hl,(fatnum)
	sla	l
	rl	h
	sla	l
	rl	h
	sla	l
	rl	h
	ld	de,lbafile-2*8
	add	hl,de
	ld	(lba),hl
frw1:
	ld	hl,(fileptr)
	ld	a,h
	and	1
	ld	h,a
	push	hl
	ex	de,hl
	ld	hl,200h
	sbc	hl,de
	ex	de,hl	;de=remain in buffer
	ld	hl,(count)
	call	5ed3h
	jr	nc,frw3
	ld	c,l
	ld	b,h
	ld	hl,0
	jr	frw4
frw3:
	ld	c,e
	ld	b,d
	sbc	hl,de
frw4:
	ld	(count),hl
	pop	hl
	ld	de,buffer
	add	hl,de
	ld	de,(memptr)
frwop1:
	defb	0
	push	bc
	ldir
	defb	0edh
frwop2:
	defb	0
	defw	memptr
	pop	bc
	ld	hl,(fileptr)
	add	hl,bc
	ld	(fileptr),hl
	ld	a,h
	and	0fh
	or	l
	jr	nz,frw5
	defb	18h
frwop3:
	defb	0	;@R none @W frw5
frw7:
	ld	hl,(fatnum)
	call	nextfat
	ld	(fatnum),de
frw5:
	ld	hl,(count)
	ld	a,l
	or	h
	jp	nz,frw6
	ret

; ********** FAT handling **********

; returns vacant entry as next fat, finding from current fat.
; if current fat is vacant, link to next fat.

; in  HL current fat number
; out DE next fat number
; use A,F,B,C,D,E,H,L

savefat:
	push	hl
savefat1:
	inc	hl
	ld	de,MAXFAT
	call	5ed3h
	jp	nc,44a5h	; FAT full
	push	hl
	or	a
	call	nextfat
	pop	hl
	ld	a,e
	or	d
	jr	nz,savefat1
	ex	(sp),hl
	push	hl
	or	a
	call	nextfat	; check current is vacant or not
	pop	hl
	ld	a,e
	or	d
	jr	nz,savefat2
	pop	bc
	push	bc
	scf
	call	nextfat ; set current to new value
savefat2:
	pop	de
	ret

; in  HL current fat number
;     BC new current fat value (valid if CY=1)
;     CY set new current fat value
; out DE next fat number
; use A,F,B,C,D,E,H,L

nextfat:
	push	af
	ld	a,l
	ld	e,l
	ld	d,h
	srl	h
	rr	l
	add	hl,de
	ld	de,fat
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	and	1
	jr	nz,nextfat1
	ld	a,d
	and	0fh
	ld	d,a
	pop	af
	ret	nc
	ld	a,(hl)
	and	0f0h
	or	b
	ld	(hl),a
	dec	hl
	ld	(hl),c
	ret
nextfat1:
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	pop	af
	ret	nc
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	ld	(hl),b
	dec	hl
	ld	a,(hl)
	and	0fh
	or	c
	ld	(hl),a
	ret

; ********** ATA handling **********

readbuf:
	ld	a,1
	ld	de,buffer
	; fall

; ATA read/write
; in  A  # of sectors
;     DE buffer address
;     HL LBA
; use A,F,D,E,H,L

read:
	push	hl
	ld	hl,rwop
	ld	(hl),0dbh
	inc	hl
	ld	(hl),0e0h
	inc	hl
	ld	(hl),12h
	jr	rw
write:
	push	hl
	ld	hl,rwop
	ld	(hl),1ah
	inc	hl
	ld	(hl),0d3h
	inc	hl
	ld	(hl),0e0h
rw:
	pop	hl
	push	af
	call	devsel
	pop	af
	out	(ata+2),a
	ld	a,l		; start LBA
	out	(ata+3),a
	ld	a,h
	out	(ata+4),a
	xor	a
	out	(ata+5),a
	ld	a,40h	; LBA
	out	(ata+6),a
	ld	a,(rwop)
	cp	0dbh
	ld	a,20h	; read sectors
	jr	z,rw3
	ld	a,30h	; write sectors
rw3:
	out	(ata+7),a
rw1:
	in	a,(ata+7)
	bit	7,a
	jr	nz,rw1
	bit	3,a
	ret	z
rwop:
	nop
	nop
	nop
	inc	de
	jr	rw1

; use A,F

devsel:
	in	a,(ata+7)
	and	88h
	jr	nz,devsel
	out	(ata+6),a
devsel1:
	in	a,(ata+7)
	and	88h
	jr	nz,devsel1
	ret

; ********** Utility **********

; in  A  n
;     DE str1
;     HL str2
; use A,F,D,E
; out Z

strncmp:
	push	bc
	push	hl
	ld	b,a
strncmp2:
	ld	a,(de)
	inc	de
	cp	(hl)
	inc	hl
	jr	nz,strncmp1
	djnz	strncmp2
strncmp1:
	pop	hl
	pop	bc
	ret

strz:
	ld	a,(hl)
	or	a
	ret

; in  HL address
;     B  count
; use A,F,B,H,L

bzero:
	xor	a
bzero1:
	ld	(hl),a
	inc	hl
	djnz	bzero1
	ret

; ********** Work **********

	org	7000h
fat:	defs	0c00h
buffer:	defs	200h
header:	defs	10h
str:	defs	10h
dirent:	defs	20h
fatnum:	defs	2
lba:	defs	2
memptr:	defs	2
fileptr:	defs	2
count:	defs	2
entry:	defs	2
dirlba:	defs	2
	org	7ffch
mstart:	defs	2
mend:	defs	2

