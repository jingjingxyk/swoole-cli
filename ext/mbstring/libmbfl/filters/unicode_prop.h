/*
 * "streamable kanji code filter and converter"
 * Copyright (c) 1998-2002 HappySize, Inc. All rights reserved.
 *
 * LICENSE NOTICES
 *
 * This file is part of "streamable kanji code filter and converter",
 * which is distributed under the terms of GNU Lesser General Public
 * License (version 2) as published by the Free Software Foundation.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with "streamable kanji code filter and converter";
 * if not, write to the Free Software Foundation, Inc., 59 Temple Place,
 * Suite 330, Boston, MA  02111-1307  USA
 *
 * The authors of this file: PHP3 Internationalization team
 */

/* Should we use QPrint-encoding in MIME Header encoded-word? */
static const unsigned char mime_char_needs_qencode[] = {
/* NUL 0  */  1,
/* SCH 1  */  1,
/* SIX 2  */  1,
/* EIX 3  */  1,
/* EOT 4  */  1,
/* ENQ 5  */  1,
/* ACK 6  */  1,
/* BEL 7  */  1,
/* BS  8  */  1,
/* HI  9  */  1,
/* LF  10 */  1,
/* VI  11 */  1,
/* FF  12 */  1,
/* CR  13 */  1,
/* SO  14 */  1,
/* SI  15 */  1,
/* SLE 16 */  1,
/* CSI 17 */  1,
/* DC2 18 */  1,
/* DC3 19 */  1,
/* DC4 20 */  1,
/* NAK 21 */  1,
/* SYN 22 */  1,
/* EIB 23 */  1,
/* CAN 24 */  1,
/* EM  25 */  1,
/* SLB 26 */  1,
/* ESC 27 */  1,
/* FS  28 */  1,
/* GS  29 */  1,
/* RS  30 */  1,
/* US  31 */  1,
/* SP  32 */  1,
/* !   33 */  0,
/* "   34 */  1,
/* #   35 */  1,
/* $   36 */  1,
/* %   37 */  1,
/* &   38 */  1,
/* '   39 */  1,
/* (   40 */  1,
/* )   41 */  1,
/* *   42 */  0,
/* +   43 */  0,
/* ,   44 */  1,
/* -   45 */  0,
/* .   46 */  1,
/* /   47 */  0,
/* 0   48 */  1,
/* 1   49 */  1,
/* 2   50 */  1,
/* 3   51 */  1,
/* 4   52 */  1,
/* 5   53 */  1,
/* 6   54 */  1,
/* 7   55 */  1,
/* 8   56 */  1,
/* 9   57 */  1,
/* :   58 */  1,
/* ;   59 */  1,
/* <   60 */  1,
/* =   61 */  0,
/* >   62 */  1,
/* ?   63 */  1,
/* @   64 */  1,
/* A   65 */  0,
/* B   66 */  0,
/* C   67 */  0,
/* D   68 */  0,
/* E   69 */  0,
/* F   70 */  0,
/* G   71 */  0,
/* H   72 */  0,
/* I   73 */  0,
/* J   74 */  0,
/* K   75 */  0,
/* L   76 */  0,
/* M   77 */  0,
/* N   78 */  0,
/* O   79 */  0,
/* P   80 */  0,
/* Q   81 */  0,
/* R   82 */  0,
/* S   83 */  0,
/* T   84 */  0,
/* U   85 */  0,
/* V   86 */  0,
/* W   87 */  0,
/* X   88 */  0,
/* Y   89 */  0,
/* Z   90 */  0,
/* [   91 */  1,
/* \   92 */  1,
/* ]   93 */  1,
/* ^   94 */  1,
/* _   95 */  1,
/* `   96 */  1,
/* a   97 */  0,
/* b   98 */  0,
/* c   99 */  0,
/* d  100 */  0,
/* e  101 */  0,
/* f  102 */  0,
/* g  103 */  0,
/* h  104 */  0,
/* i  105 */  0,
/* j  106 */  0,
/* k  107 */  0,
/* l  108 */  0,
/* m  109 */  0,
/* n  110 */  0,
/* o  111 */  0,
/* p  112 */  0,
/* q  113 */  0,
/* r  114 */  0,
/* s  115 */  0,
/* t  116 */  0,
/* u  117 */  0,
/* v  118 */  0,
/* w  119 */  0,
/* x  120 */  0,
/* y  121 */  0,
/* z  122 */  0,
/* {  123 */  1,
/* |  124 */  1,
/* }  125 */  1,
/* ~  126 */  1,
/* DEL 127 */ 1
};