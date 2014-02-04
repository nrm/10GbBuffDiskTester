#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Конфигурационный файл
программы управления ШСПС
"""

HOST    = "172.22.222.123"
HOST_1    = "172.22.222.123"
HOST_2    = "172.22.222.124"
#HOST    = "127.0.0.1"
PORT    = 4001
#PORT    = 50007
ECHO    = 3   # ????



#MAC ADDRESS
DST_MAC_ADDR_FF     = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
DST_MAC_ADDR_ETH5   = [0x90, 0xe2, 0xba, 0x20, 0x92, 0x2d]
DST_MAC_ADDR_ETH4   = [0x90, 0xe2, 0xba, 0x20, 0x92, 0x2c]
DST_MAC_ADDR_ix0    = [0x90, 0xe2, 0xba, 0x20, 0x94, 0x70]
DST_MAC_ADDR_ix1    = [0x90, 0xe2, 0xba, 0x20, 0x94, 0x71]
DST_MAC_ADDR_ix2    = [0xa0, 0x36, 0x9f, 0x26, 0x91, 0x10]
DST_MAC_ADDR_ix3    = [0xa0, 0x36, 0x9f, 0x26, 0x91, 0x12]
SRC_MAC_ADDR_C1     = [0x80, 0x87, 0x87, 0x87, 0x87, 0xC1]
SRC_MAC_ADDR_C2     = [0x80, 0x87, 0x87, 0x87, 0x87, 0xC2]

SRC_MAC_ADDR_124_C1     = [0x80, 0x87, 0x87, 0x87, 0x87, 0xC3]
SRC_MAC_ADDR_124_C2     = [0x80, 0x87, 0x87, 0x87, 0x87, 0xC4]



CMD_NAME				= 	0x00
CMD_VERSION				= 	0x01
CMD_GET_STAT_REG        =   0x02
CMD_TEMPERATURE         =   0x03
CMD_CURRENT				= 	0x04
CMD_ADC_CAL				= 	0x05
CMD_ATT_SET				= 	0x06
CMD_ATT_GET				= 	0x07
CMD_AGC_EN				= 	0x08
CMD_SPECTRUM_INV        =   0x09
CMD_GET_PWR				= 	0x0A
CMD_GET_STATISTICS      =   0x0B
CMD_GET_8BITS_SAMPLES   =   0x0C
CMD_GET_2BITS_SAMPLES   =   0x0D
CMD_GET_MEAN            =   0x0E
CMD_SHIFT_ADC_OFFSET    =   0x0F
CMD_GET_PCAL            =   0x10
CMD_ADC_EN				= 	0x11
CMD_STATISTICS_EN       =   0x12
CMD_PCAL_EN				= 	0x13
CMD_PPS_SYNC            =   0x14
CMD_GET_PPS_ERR         =   0x15
CMD_SET_TIME            =   0x16
CMD_GET_TIME            =   0x17
CMD_VDIF_TEST_MODE      =   0x18
CMD_SET_REC_STARTTIME   =   0x19
CMD_SET_REC_STOPTIME    =   0x1A
CMD_SET_MAC_ADDR        =   0x1B
CMD_GET_MAC_ADDR        =   0x1C


# State register bits
SREG_ADF4106_LD		=		(1<<0)
SREG_SPECTRUM_INV	=		(1<<1)
SREG_AGC_EN			=	(1<<2)
SREG_ADC_EN			=	(1<<3)
SREG_STATISTICS_EN	=		(1<<4)
SREG_PCAL_EN		=		(1<<5)
SREG_X2_LASI		=		(1<<6)
SREG_X2_PWR_ON		=		(1<<7)
SREG_X2_MOD_DET		=		(1<<8)
SREG_PPS_AVL		=		(1<<9)
SREG_REC_STATUS		=		(1<<10)
SREG_VDIF_TEST_MODE	=		(1<<11)

R3305_ADDR_1		=		0x01
R3305_ADDR_2		=		0x02

