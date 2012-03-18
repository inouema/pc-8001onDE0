/////////////////////////////////////////////////////////////////////////////
// FPGA PACMAN design select switch
//
// Version : 0.92
//
// Copyright(c) 2004 Tatsuyuki Satoh , All rights reserved
//
// Important !
//
// This software is freeware for non-commercial use. 
// This software is provided "AS IS", without warranty of any kind.
// You can use this under your own risk. 
//
/////////////////////////////////////////////////////////////////////////////

`ifndef __SWITCH_V__
`define  __SWITCH_V__

//------------------------------------- DSW1
//coinage : FREE , 1C/1C , 1C/2C , 2C/1C
`define COINAGE_FREE 2'b00
`define COINAGE_1C1C 2'b01
`define COINAGE_1C2C 2'b10
`define COINAGE_2C1C 2'b11

//lives : 1 , 2 , 3 , 5
`define LIVES_1 2'b00
`define LIVES_2 2'b01
`define LIVES_3 2'b10
`define LIVES_5 2'b11

//bonus : 10000 , 15000 , 20000 , NONE
`define BONUS_10000 2'b00
`define BONUS_15000 2'b01
`define BONUS_20000 2'b10
`define BONUS_NOOE  2'b11

//diffic : hard , normal
`define DIFF_HARD   1'b0
`define DIFF_NORMAL 1'b1

//game name select
`define GNAME_1 1'b0
`define GNAME_2 1'b1

`define DSW1 {`GNAME_2,`DIFF_NORMAL,`BONUS_10000,`LIVES_3,`COINAGE_1C1C }

//------------------------------------- DSW2
`define DSW2 0

//-------------------------------------- PROM size(MSB bit) & bank
`define ROM_MSB  18 // 4MBit
`define ROM_BANK 3'b000 // 00000-0ffff 29EE020

//-------------------------------------- HID module select
//`define HID_MODULE hid_pspd   // PSX PAD
`define HID_MODULE hid_sw    // direct switch

//-------------------------------------- Sound Encoder select
`define SENC_MODULE senc_sd   // SigmaDelta Analog
//`define SENC_MODULE senc_spd  // SPDIF Digital
//`define SENC_MODULE senc_dmy  // dummy(no-sound)

//-------------------------------------- Video Encoder select
//`define VENC_MODULE venc_rgb8  // 8bpp 16KHz RGB
`define VENC_MODULE venc_vga8  // 8bpp VGA
//`define VENC_MODULE venc_ntsc // NTSC
//`define VENC_MODULE venc_hdtv // HDTV

//------------------------------------- ROM upload mode
// setup mode select
//`define CFR_LOAD  // load all ROM from Configration-ROM
`define PROM_LOAD // load internal ROM from external PROM

//------------------------------------- internal memory module
`define IMEM_MODULE im_xc2s // Xilinx Spartan2 BlockRam
//`define IMEM_MODULE im_gen  // generic RAM

//------------------------------------- OnScreenDisplay
`define ENABLE_OSD

//------------------------------------- Z80 select
`define MCPU_FZ80C   // fz80 soft core
//`define MCPU_TV80C // TV80 soft core
//`define MCPU_EXT_Z80 // external Z80

`endif
