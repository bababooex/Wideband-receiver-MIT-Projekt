   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.3 - 22 Aug 2024
  15                     	bsct
  16  0000               _force_lcd_update:
  17  0000 0000          	dc.w	0
  88                     ; 30 void int_to_string(int num, char *str) {
  90                     	switch	.text
  91  0000               _int_to_string:
  93  0000 89            	pushw	x
  94  0001 5203          	subw	sp,#3
  95       00000003      OFST:	set	3
  98                     ; 31     int i = 0;
 100  0003 5f            	clrw	x
 101  0004 1f02          	ldw	(OFST-1,sp),x
 103  0006               L34:
 104                     ; 33         str[i++] = (num % 10) + '0';
 106  0006 1e04          	ldw	x,(OFST+1,sp)
 107  0008 a60a          	ld	a,#10
 108  000a cd0000        	call	c_smodx
 110  000d 1c0030        	addw	x,#48
 111  0010 1602          	ldw	y,(OFST-1,sp)
 112  0012 72a90001      	addw	y,#1
 113  0016 1702          	ldw	(OFST-1,sp),y
 114  0018 72a20001      	subw	y,#1
 116  001c 72f908        	addw	y,(OFST+5,sp)
 117  001f 01            	rrwa	x,a
 118  0020 90f7          	ld	(y),a
 119  0022 02            	rlwa	x,a
 120                     ; 34         num /= 10;
 122  0023 1e04          	ldw	x,(OFST+1,sp)
 123  0025 a60a          	ld	a,#10
 124  0027 cd0000        	call	c_sdivx
 126  002a 1f04          	ldw	(OFST+1,sp),x
 127                     ; 35     } while (num > 0);    
 129  002c 9c            	rvf
 130  002d 1e04          	ldw	x,(OFST+1,sp)
 131  002f 2cd5          	jrsgt	L34
 132                     ; 36 		str[i] = '\0';
 134  0031 1e02          	ldw	x,(OFST-1,sp)
 135  0033 72fb08        	addw	x,(OFST+5,sp)
 136  0036 7f            	clr	(x)
 137                     ; 37     for (j = 0, k = i - 1; j < k; j++, k--) {
 139  0037 ae0000        	ldw	x,#0
 140  003a bf35          	ldw	_j+2,x
 141  003c ae0000        	ldw	x,#0
 142  003f bf33          	ldw	_j,x
 143  0041 1e02          	ldw	x,(OFST-1,sp)
 144  0043 5a            	decw	x
 145  0044 cd0000        	call	c_itolx
 147  0047 ae002f        	ldw	x,#_k
 148  004a cd0000        	call	c_rtol
 151  004d 2026          	jra	L55
 152  004f               L15:
 153                     ; 38         char temp = str[j];
 155  004f 1e08          	ldw	x,(OFST+5,sp)
 156  0051 92d635        	ld	a,([_j+2.w],x)
 157  0054 6b01          	ld	(OFST-2,sp),a
 159                     ; 39         str[j] = str[k];
 161  0056 1e08          	ldw	x,(OFST+5,sp)
 162  0058 92d631        	ld	a,([_k+2.w],x)
 163  005b 92d735        	ld	([_j+2.w],x),a
 164                     ; 40         str[k] = temp;
 166  005e 7b01          	ld	a,(OFST-2,sp)
 167  0060 1e08          	ldw	x,(OFST+5,sp)
 168  0062 92d731        	ld	([_k+2.w],x),a
 169                     ; 37     for (j = 0, k = i - 1; j < k; j++, k--) {
 171  0065 ae0033        	ldw	x,#_j
 172  0068 a601          	ld	a,#1
 173  006a cd0000        	call	c_lgadc
 175  006d ae002f        	ldw	x,#_k
 176  0070 a601          	ld	a,#1
 177  0072 cd0000        	call	c_lgsbc
 179  0075               L55:
 182  0075 9c            	rvf
 183  0076 ae0033        	ldw	x,#_j
 184  0079 cd0000        	call	c_ltor
 186  007c ae002f        	ldw	x,#_k
 187  007f cd0000        	call	c_lcmp
 189  0082 2fcb          	jrslt	L15
 190                     ; 42 }
 193  0084 5b05          	addw	sp,#5
 194  0086 81            	ret
 197                     	bsct
 198  0002               L16_lastValue:
 199  0002 ffff          	dc.w	-1
 200  0004 ffff          	dc.w	-1
 201  0006 ffff          	dc.w	-1
 202                     .const:	section	.text
 203  0000               L36_buffer:
 204  0000 20202000      	dc.b	"   ",0
 287                     ; 44 void Lcd_Print_Int_At1(uint8_t row, uint8_t col, int number) {
 288                     	switch	.text
 289  0087               _Lcd_Print_Int_At1:
 291  0087 89            	pushw	x
 292  0088 5206          	subw	sp,#6
 293       00000006      OFST:	set	6
 296                     ; 46     int index = (col == 2) ? 0 : (col == 5) ? 1 : 2; 
 298  008a 9f            	ld	a,xl
 299  008b a102          	cp	a,#2
 300  008d 2603          	jrne	L01
 301  008f 5f            	clrw	x
 302  0090 200d          	jra	L21
 303  0092               L01:
 304  0092 9f            	ld	a,xl
 305  0093 a105          	cp	a,#5
 306  0095 2605          	jrne	L41
 307  0097 ae0001        	ldw	x,#1
 308  009a 2003          	jra	L61
 309  009c               L41:
 310  009c ae0002        	ldw	x,#2
 311  009f               L61:
 312  009f               L21:
 313  009f 1f01          	ldw	(OFST-5,sp),x
 315                     ; 47     char buffer[4] = "   ";  
 317  00a1 96            	ldw	x,sp
 318  00a2 1c0003        	addw	x,#OFST-3
 319  00a5 90ae0000      	ldw	y,#L36_buffer
 320  00a9 a604          	ld	a,#4
 321  00ab cd0000        	call	c_xymov
 323                     ; 49     if (force_lcd_update || lastValue[index] != number) {
 325  00ae be00          	ldw	x,_force_lcd_update
 326  00b0 260d          	jrne	L131
 328  00b2 1e01          	ldw	x,(OFST-5,sp)
 329  00b4 58            	sllw	x
 330  00b5 9093          	ldw	y,x
 331  00b7 51            	exgw	x,y
 332  00b8 ee02          	ldw	x,(L16_lastValue,x)
 333  00ba 130b          	cpw	x,(OFST+5,sp)
 334  00bc 51            	exgw	x,y
 335  00bd 273b          	jreq	L721
 336  00bf               L131:
 337                     ; 50         lastValue[index] = number;  
 339  00bf 1e01          	ldw	x,(OFST-5,sp)
 340  00c1 58            	sllw	x
 341  00c2 160b          	ldw	y,(OFST+5,sp)
 342  00c4 ef02          	ldw	(L16_lastValue,x),y
 343                     ; 51         int_to_string(number, buffer);  
 345  00c6 96            	ldw	x,sp
 346  00c7 1c0003        	addw	x,#OFST-3
 347  00ca 89            	pushw	x
 348  00cb 1e0d          	ldw	x,(OFST+7,sp)
 349  00cd cd0000        	call	_int_to_string
 351  00d0 85            	popw	x
 352                     ; 52 				Lcd_Set_Cursor(row, col);  
 354  00d1 7b08          	ld	a,(OFST+2,sp)
 355  00d3 97            	ld	xl,a
 356  00d4 7b07          	ld	a,(OFST+1,sp)
 357  00d6 95            	ld	xh,a
 358  00d7 cd0299        	call	_Lcd_Set_Cursor
 360                     ; 53         Lcd_Print_String("   ");
 362  00da ae01fd        	ldw	x,#L331
 363  00dd cd0339        	call	_Lcd_Print_String
 365                     ; 54         Lcd_Set_Cursor(row, col);  
 367  00e0 7b08          	ld	a,(OFST+2,sp)
 368  00e2 97            	ld	xl,a
 369  00e3 7b07          	ld	a,(OFST+1,sp)
 370  00e5 95            	ld	xh,a
 371  00e6 cd0299        	call	_Lcd_Set_Cursor
 373                     ; 55         Lcd_Print_String(buffer);  
 375  00e9 96            	ldw	x,sp
 376  00ea 1c0003        	addw	x,#OFST-3
 377  00ed cd0339        	call	_Lcd_Print_String
 379                     ; 57 				if (force_lcd_update==1) {
 381  00f0 be00          	ldw	x,_force_lcd_update
 382  00f2 a30001        	cpw	x,#1
 383  00f5 2603          	jrne	L721
 384                     ; 58 				force_lcd_update = 0;
 386  00f7 5f            	clrw	x
 387  00f8 bf00          	ldw	_force_lcd_update,x
 388  00fa               L721:
 389                     ; 61 }
 392  00fa 5b08          	addw	sp,#8
 393  00fc 81            	ret
 396                     	bsct
 397  0008               L731_lastValue:
 398  0008 ffff          	dc.w	-1
 399                     	switch	.const
 400  0004               L141_buffer:
 401  0004 2000          	dc.b	" ",0
 484                     ; 63 void Lcd_Print_Int_At2(uint8_t row, uint8_t col, int number) {
 485                     	switch	.text
 486  00fd               _Lcd_Print_Int_At2:
 488  00fd 89            	pushw	x
 489  00fe 5204          	subw	sp,#4
 490       00000004      OFST:	set	4
 493                     ; 65     int index = (col == 2) ? 0 : (col == 5) ? 1 : 2;  
 495  0100 9f            	ld	a,xl
 496  0101 a102          	cp	a,#2
 497  0103 2603          	jrne	L22
 498  0105 5f            	clrw	x
 499  0106 200d          	jra	L42
 500  0108               L22:
 501  0108 9f            	ld	a,xl
 502  0109 a105          	cp	a,#5
 503  010b 2605          	jrne	L62
 504  010d ae0001        	ldw	x,#1
 505  0110 2003          	jra	L03
 506  0112               L62:
 507  0112 ae0002        	ldw	x,#2
 508  0115               L03:
 509  0115               L42:
 510  0115 1f01          	ldw	(OFST-3,sp),x
 512                     ; 66     char buffer[2] = " ";  
 514  0117 c60004        	ld	a,L141_buffer
 515  011a 6b03          	ld	(OFST-1,sp),a
 516  011c c60005        	ld	a,L141_buffer+1
 517  011f 6b04          	ld	(OFST+0,sp),a
 518                     ; 67     if (force_lcd_update || lastValue[index] != number) {
 520  0121 be00          	ldw	x,_force_lcd_update
 521  0123 260d          	jrne	L702
 523  0125 1e01          	ldw	x,(OFST-3,sp)
 524  0127 58            	sllw	x
 525  0128 9093          	ldw	y,x
 526  012a 51            	exgw	x,y
 527  012b ee08          	ldw	x,(L731_lastValue,x)
 528  012d 1309          	cpw	x,(OFST+5,sp)
 529  012f 51            	exgw	x,y
 530  0130 273b          	jreq	L502
 531  0132               L702:
 532                     ; 68         lastValue[index] = number;
 534  0132 1e01          	ldw	x,(OFST-3,sp)
 535  0134 58            	sllw	x
 536  0135 1609          	ldw	y,(OFST+5,sp)
 537  0137 ef08          	ldw	(L731_lastValue,x),y
 538                     ; 69         int_to_string(number, buffer);  
 540  0139 96            	ldw	x,sp
 541  013a 1c0003        	addw	x,#OFST-1
 542  013d 89            	pushw	x
 543  013e 1e0b          	ldw	x,(OFST+7,sp)
 544  0140 cd0000        	call	_int_to_string
 546  0143 85            	popw	x
 547                     ; 70         Lcd_Set_Cursor(row, col);  
 549  0144 7b06          	ld	a,(OFST+2,sp)
 550  0146 97            	ld	xl,a
 551  0147 7b05          	ld	a,(OFST+1,sp)
 552  0149 95            	ld	xh,a
 553  014a cd0299        	call	_Lcd_Set_Cursor
 555                     ; 71         Lcd_Print_String(" "); 
 557  014d ae01fb        	ldw	x,#L112
 558  0150 cd0339        	call	_Lcd_Print_String
 560                     ; 72         Lcd_Set_Cursor(row, col);  
 562  0153 7b06          	ld	a,(OFST+2,sp)
 563  0155 97            	ld	xl,a
 564  0156 7b05          	ld	a,(OFST+1,sp)
 565  0158 95            	ld	xh,a
 566  0159 cd0299        	call	_Lcd_Set_Cursor
 568                     ; 73         Lcd_Print_String(buffer);
 570  015c 96            	ldw	x,sp
 571  015d 1c0003        	addw	x,#OFST-1
 572  0160 cd0339        	call	_Lcd_Print_String
 574                     ; 75         if (force_lcd_update==1) {
 576  0163 be00          	ldw	x,_force_lcd_update
 577  0165 a30001        	cpw	x,#1
 578  0168 2603          	jrne	L502
 579                     ; 76 				force_lcd_update = 0;
 581  016a 5f            	clrw	x
 582  016b bf00          	ldw	_force_lcd_update,x
 583  016d               L502:
 584                     ; 79 }
 587  016d 5b06          	addw	sp,#6
 588  016f 81            	ret
 624                     ; 81 void Lcd_SetBit(char data_bit) 
 624                     ; 82 {
 625                     	switch	.text
 626  0170               _Lcd_SetBit:
 628  0170 88            	push	a
 629       00000000      OFST:	set	0
 632                     ; 83     if(data_bit& 1) 
 634  0171 a501          	bcp	a,#1
 635  0173 270b          	jreq	L332
 636                     ; 84         GPIO_WriteHigh(LCD_DB4); //D4 = 1
 638  0175 4b01          	push	#1
 639  0177 ae5014        	ldw	x,#20500
 640  017a cd0000        	call	_GPIO_WriteHigh
 642  017d 84            	pop	a
 644  017e 2009          	jra	L532
 645  0180               L332:
 646                     ; 86         GPIO_WriteLow(LCD_DB4); //D4=0
 648  0180 4b01          	push	#1
 649  0182 ae5014        	ldw	x,#20500
 650  0185 cd0000        	call	_GPIO_WriteLow
 652  0188 84            	pop	a
 653  0189               L532:
 654                     ; 88     if(data_bit& 2)
 656  0189 7b01          	ld	a,(OFST+1,sp)
 657  018b a502          	bcp	a,#2
 658  018d 270b          	jreq	L732
 659                     ; 89         GPIO_WriteHigh(LCD_DB5); //D5 = 1
 661  018f 4b02          	push	#2
 662  0191 ae500a        	ldw	x,#20490
 663  0194 cd0000        	call	_GPIO_WriteHigh
 665  0197 84            	pop	a
 667  0198 2009          	jra	L142
 668  019a               L732:
 669                     ; 91         GPIO_WriteLow(LCD_DB5); //D5=0
 671  019a 4b02          	push	#2
 672  019c ae500a        	ldw	x,#20490
 673  019f cd0000        	call	_GPIO_WriteLow
 675  01a2 84            	pop	a
 676  01a3               L142:
 677                     ; 93     if(data_bit& 4)
 679  01a3 7b01          	ld	a,(OFST+1,sp)
 680  01a5 a504          	bcp	a,#4
 681  01a7 270b          	jreq	L342
 682                     ; 94         GPIO_WriteHigh(LCD_DB6); //D6 = 1
 684  01a9 4b01          	push	#1
 685  01ab ae501e        	ldw	x,#20510
 686  01ae cd0000        	call	_GPIO_WriteHigh
 688  01b1 84            	pop	a
 690  01b2 2009          	jra	L542
 691  01b4               L342:
 692                     ; 96         GPIO_WriteLow(LCD_DB6); //D6=0
 694  01b4 4b01          	push	#1
 695  01b6 ae501e        	ldw	x,#20510
 696  01b9 cd0000        	call	_GPIO_WriteLow
 698  01bc 84            	pop	a
 699  01bd               L542:
 700                     ; 98     if(data_bit& 8) 
 702  01bd 7b01          	ld	a,(OFST+1,sp)
 703  01bf a508          	bcp	a,#8
 704  01c1 270b          	jreq	L742
 705                     ; 99         GPIO_WriteHigh(LCD_DB7); //D7 = 1
 707  01c3 4b04          	push	#4
 708  01c5 ae500a        	ldw	x,#20490
 709  01c8 cd0000        	call	_GPIO_WriteHigh
 711  01cb 84            	pop	a
 713  01cc 2009          	jra	L152
 714  01ce               L742:
 715                     ; 101         GPIO_WriteLow(LCD_DB7); //D7=0
 717  01ce 4b04          	push	#4
 718  01d0 ae500a        	ldw	x,#20490
 719  01d3 cd0000        	call	_GPIO_WriteLow
 721  01d6 84            	pop	a
 722  01d7               L152:
 723                     ; 102 }
 726  01d7 84            	pop	a
 727  01d8 81            	ret
 765                     ; 104 void Lcd_Cmd(char a)
 765                     ; 105 {
 766                     	switch	.text
 767  01d9               _Lcd_Cmd:
 769  01d9 88            	push	a
 770       00000000      OFST:	set	0
 773                     ; 106     GPIO_WriteLow(LCD_RS); //RS = 0          
 775  01da 4b40          	push	#64
 776  01dc ae500f        	ldw	x,#20495
 777  01df cd0000        	call	_GPIO_WriteLow
 779  01e2 84            	pop	a
 780                     ; 107     Lcd_SetBit(a); //Incoming Hex value
 782  01e3 7b01          	ld	a,(OFST+1,sp)
 783  01e5 ad89          	call	_Lcd_SetBit
 785                     ; 108     GPIO_WriteHigh(LCD_EN); //EN  = 1         
 787  01e7 4b20          	push	#32
 788  01e9 ae500f        	ldw	x,#20495
 789  01ec cd0000        	call	_GPIO_WriteHigh
 791  01ef 84            	pop	a
 792                     ; 109 		delay_ms(2);
 794  01f0 ae0002        	ldw	x,#2
 795  01f3 cd0000        	call	_delay_ms
 797                     ; 110 		GPIO_WriteLow(LCD_EN); //EN  = 0      
 799  01f6 4b20          	push	#32
 800  01f8 ae500f        	ldw	x,#20495
 801  01fb cd0000        	call	_GPIO_WriteLow
 803  01fe 84            	pop	a
 804                     ; 111 }
 807  01ff 84            	pop	a
 808  0200 81            	ret
 835                     ; 115  void Lcd_Begin(void)
 835                     ; 116  {
 836                     	switch	.text
 837  0201               _Lcd_Begin:
 841                     ; 118 	 GPIO_Init(LCD_RS, GPIO_MODE_OUT_PP_HIGH_FAST);
 843  0201 4bf0          	push	#240
 844  0203 4b40          	push	#64
 845  0205 ae500f        	ldw	x,#20495
 846  0208 cd0000        	call	_GPIO_Init
 848  020b 85            	popw	x
 849                     ; 119 	 GPIO_Init(LCD_EN, GPIO_MODE_OUT_PP_HIGH_FAST);
 851  020c 4bf0          	push	#240
 852  020e 4b20          	push	#32
 853  0210 ae500f        	ldw	x,#20495
 854  0213 cd0000        	call	_GPIO_Init
 856  0216 85            	popw	x
 857                     ; 120 	 GPIO_Init(LCD_DB4, GPIO_MODE_OUT_PP_HIGH_FAST);
 859  0217 4bf0          	push	#240
 860  0219 4b01          	push	#1
 861  021b ae5014        	ldw	x,#20500
 862  021e cd0000        	call	_GPIO_Init
 864  0221 85            	popw	x
 865                     ; 121 	 GPIO_Init(LCD_DB5, GPIO_MODE_OUT_PP_HIGH_FAST);
 867  0222 4bf0          	push	#240
 868  0224 4b02          	push	#2
 869  0226 ae500a        	ldw	x,#20490
 870  0229 cd0000        	call	_GPIO_Init
 872  022c 85            	popw	x
 873                     ; 122 	 GPIO_Init(LCD_DB6, GPIO_MODE_OUT_PP_HIGH_FAST);
 875  022d 4bf0          	push	#240
 876  022f 4b01          	push	#1
 877  0231 ae501e        	ldw	x,#20510
 878  0234 cd0000        	call	_GPIO_Init
 880  0237 85            	popw	x
 881                     ; 123 	 GPIO_Init(LCD_DB7, GPIO_MODE_OUT_PP_HIGH_FAST);
 883  0238 4bf0          	push	#240
 884  023a 4b04          	push	#4
 885  023c ae500a        	ldw	x,#20490
 886  023f cd0000        	call	_GPIO_Init
 888  0242 85            	popw	x
 889                     ; 124 	 delay_ms(10);
 891  0243 ae000a        	ldw	x,#10
 892  0246 cd0000        	call	_delay_ms
 894                     ; 126 	Lcd_SetBit(0x00);
 896  0249 4f            	clr	a
 897  024a cd0170        	call	_Lcd_SetBit
 899                     ; 127 	delay_ms(1000);  //for(int i=1065244; i<=0; i--)  
 901  024d ae03e8        	ldw	x,#1000
 902  0250 cd0000        	call	_delay_ms
 904                     ; 130   Lcd_Cmd(0x03);
 906  0253 a603          	ld	a,#3
 907  0255 ad82          	call	_Lcd_Cmd
 909                     ; 131 	delay_ms(5);
 911  0257 ae0005        	ldw	x,#5
 912  025a cd0000        	call	_delay_ms
 914                     ; 133   Lcd_Cmd(0x03);
 916  025d a603          	ld	a,#3
 917  025f cd01d9        	call	_Lcd_Cmd
 919                     ; 134 	delay_ms(11);
 921  0262 ae000b        	ldw	x,#11
 922  0265 cd0000        	call	_delay_ms
 924                     ; 136   Lcd_Cmd(0x03); 
 926  0268 a603          	ld	a,#3
 927  026a cd01d9        	call	_Lcd_Cmd
 929                     ; 137   Lcd_Cmd(0x02); //02H is used for Return home -> Clears the RAM and initializes the LCD
 931  026d a602          	ld	a,#2
 932  026f cd01d9        	call	_Lcd_Cmd
 934                     ; 138   Lcd_Cmd(0x02); //02H is used for Return home -> Clears the RAM and initializes the LCD
 936  0272 a602          	ld	a,#2
 937  0274 cd01d9        	call	_Lcd_Cmd
 939                     ; 139   Lcd_Cmd(0x08); //Select Row 1
 941  0277 a608          	ld	a,#8
 942  0279 cd01d9        	call	_Lcd_Cmd
 944                     ; 140   Lcd_Cmd(0x00); //Clear Row 1 Display
 946  027c 4f            	clr	a
 947  027d cd01d9        	call	_Lcd_Cmd
 949                     ; 141   Lcd_Cmd(0x0C); //Select Row 2
 951  0280 a60c          	ld	a,#12
 952  0282 cd01d9        	call	_Lcd_Cmd
 954                     ; 142   Lcd_Cmd(0x00); //Clear Row 2 Display
 956  0285 4f            	clr	a
 957  0286 cd01d9        	call	_Lcd_Cmd
 959                     ; 143   Lcd_Cmd(0x06);
 961  0289 a606          	ld	a,#6
 962  028b cd01d9        	call	_Lcd_Cmd
 964                     ; 144  }
 967  028e 81            	ret
 991                     ; 147 void Lcd_Clear(void)
 991                     ; 148 {
 992                     	switch	.text
 993  028f               _Lcd_Clear:
 997                     ; 149     Lcd_Cmd(0); //Clear the LCD
 999  028f 4f            	clr	a
1000  0290 cd01d9        	call	_Lcd_Cmd
1002                     ; 150     Lcd_Cmd(1); //Move the curser to first position
1004  0293 a601          	ld	a,#1
1005  0295 cd01d9        	call	_Lcd_Cmd
1007                     ; 151 }
1010  0298 81            	ret
1081                     ; 153 void Lcd_Set_Cursor(char a, char b)
1081                     ; 154 {
1082                     	switch	.text
1083  0299               _Lcd_Set_Cursor:
1085  0299 89            	pushw	x
1086  029a 89            	pushw	x
1087       00000002      OFST:	set	2
1090                     ; 156     if(a== 1)
1092  029b 9e            	ld	a,xh
1093  029c a101          	cp	a,#1
1094  029e 261e          	jrne	L743
1095                     ; 158       temp = 0x80 + b - 1; //80H is used to move the curser
1097  02a0 9f            	ld	a,xl
1098  02a1 ab7f          	add	a,#127
1099  02a3 6b02          	ld	(OFST+0,sp),a
1101                     ; 159         z = temp>>4; //Lower 8-bits
1103  02a5 7b02          	ld	a,(OFST+0,sp)
1104  02a7 4e            	swap	a
1105  02a8 a40f          	and	a,#15
1106  02aa 6b01          	ld	(OFST-1,sp),a
1108                     ; 160         y = temp & 0x0F; //Upper 8-bits
1110  02ac 7b02          	ld	a,(OFST+0,sp)
1111  02ae a40f          	and	a,#15
1112  02b0 6b02          	ld	(OFST+0,sp),a
1114                     ; 161         Lcd_Cmd(z); //Set Row
1116  02b2 7b01          	ld	a,(OFST-1,sp)
1117  02b4 cd01d9        	call	_Lcd_Cmd
1119                     ; 162         Lcd_Cmd(y); //Set Column
1121  02b7 7b02          	ld	a,(OFST+0,sp)
1122  02b9 cd01d9        	call	_Lcd_Cmd
1125  02bc 2023          	jra	L153
1126  02be               L743:
1127                     ; 164     else if(a== 2)
1129  02be 7b03          	ld	a,(OFST+1,sp)
1130  02c0 a102          	cp	a,#2
1131  02c2 261d          	jrne	L153
1132                     ; 166         temp = 0xC0 + b - 1;
1134  02c4 7b04          	ld	a,(OFST+2,sp)
1135  02c6 abbf          	add	a,#191
1136  02c8 6b02          	ld	(OFST+0,sp),a
1138                     ; 167         z = temp>>4; //Lower 8-bits
1140  02ca 7b02          	ld	a,(OFST+0,sp)
1141  02cc 4e            	swap	a
1142  02cd a40f          	and	a,#15
1143  02cf 6b01          	ld	(OFST-1,sp),a
1145                     ; 168         y = temp & 0x0F; //Upper 8-bits
1147  02d1 7b02          	ld	a,(OFST+0,sp)
1148  02d3 a40f          	and	a,#15
1149  02d5 6b02          	ld	(OFST+0,sp),a
1151                     ; 169         Lcd_Cmd(z); //Set Row
1153  02d7 7b01          	ld	a,(OFST-1,sp)
1154  02d9 cd01d9        	call	_Lcd_Cmd
1156                     ; 170         Lcd_Cmd(y); //Set Column
1158  02dc 7b02          	ld	a,(OFST+0,sp)
1159  02de cd01d9        	call	_Lcd_Cmd
1161  02e1               L153:
1162                     ; 172 }
1165  02e1 5b04          	addw	sp,#4
1166  02e3 81            	ret
1222                     ; 174  void Lcd_Print_Char(char data)  //Send 8-bits through 4-bit mode
1222                     ; 175 {
1223                     	switch	.text
1224  02e4               _Lcd_Print_Char:
1226  02e4 88            	push	a
1227  02e5 89            	pushw	x
1228       00000002      OFST:	set	2
1231                     ; 177    Lower_Nibble = data&0x0F;
1233  02e6 a40f          	and	a,#15
1234  02e8 6b01          	ld	(OFST-1,sp),a
1236                     ; 178    Upper_Nibble = data&0xF0;
1238  02ea 7b03          	ld	a,(OFST+1,sp)
1239  02ec a4f0          	and	a,#240
1240  02ee 6b02          	ld	(OFST+0,sp),a
1242                     ; 179    GPIO_WriteHigh(LCD_RS);             // => RS = 1
1244  02f0 4b40          	push	#64
1245  02f2 ae500f        	ldw	x,#20495
1246  02f5 cd0000        	call	_GPIO_WriteHigh
1248  02f8 84            	pop	a
1249                     ; 181    Lcd_SetBit(Upper_Nibble>>4);             //Send upper half by shifting by 4
1251  02f9 7b02          	ld	a,(OFST+0,sp)
1252  02fb 4e            	swap	a
1253  02fc a40f          	and	a,#15
1254  02fe cd0170        	call	_Lcd_SetBit
1256                     ; 182    GPIO_WriteHigh(LCD_EN); //EN = 1
1258  0301 4b20          	push	#32
1259  0303 ae500f        	ldw	x,#20495
1260  0306 cd0000        	call	_GPIO_WriteHigh
1262  0309 84            	pop	a
1263                     ; 183    delay_ms(5); //for(int i=2130483; i<=0; i--)  NOP(); 
1265  030a ae0005        	ldw	x,#5
1266  030d cd0000        	call	_delay_ms
1268                     ; 184    GPIO_WriteLow(LCD_EN); //EN = 0
1270  0310 4b20          	push	#32
1271  0312 ae500f        	ldw	x,#20495
1272  0315 cd0000        	call	_GPIO_WriteLow
1274  0318 84            	pop	a
1275                     ; 186    Lcd_SetBit(Lower_Nibble); //Send Lower half
1277  0319 7b01          	ld	a,(OFST-1,sp)
1278  031b cd0170        	call	_Lcd_SetBit
1280                     ; 187    GPIO_WriteHigh(LCD_EN); //EN = 1
1282  031e 4b20          	push	#32
1283  0320 ae500f        	ldw	x,#20495
1284  0323 cd0000        	call	_GPIO_WriteHigh
1286  0326 84            	pop	a
1287                     ; 188    delay_ms(5); //for(int i=2130483; i<=0; i--)  NOP();
1289  0327 ae0005        	ldw	x,#5
1290  032a cd0000        	call	_delay_ms
1292                     ; 189    GPIO_WriteLow(LCD_EN); //EN = 0
1294  032d 4b20          	push	#32
1295  032f ae500f        	ldw	x,#20495
1296  0332 cd0000        	call	_GPIO_WriteLow
1298  0335 84            	pop	a
1299                     ; 190 }
1302  0336 5b03          	addw	sp,#3
1303  0338 81            	ret
1348                     ; 192 void Lcd_Print_String(char *a)
1348                     ; 193 {
1349                     	switch	.text
1350  0339               _Lcd_Print_String:
1352  0339 89            	pushw	x
1353  033a 89            	pushw	x
1354       00000002      OFST:	set	2
1357                     ; 195     for(i=0;a[i]!='\0';i++)
1359  033b 5f            	clrw	x
1360  033c 1f01          	ldw	(OFST-1,sp),x
1363  033e 200f          	jra	L134
1364  0340               L524:
1365                     ; 196        Lcd_Print_Char(a[i]);  //Split the string using pointers and call the Char function 
1367  0340 1e01          	ldw	x,(OFST-1,sp)
1368  0342 72fb03        	addw	x,(OFST+1,sp)
1369  0345 f6            	ld	a,(x)
1370  0346 ad9c          	call	_Lcd_Print_Char
1372                     ; 195     for(i=0;a[i]!='\0';i++)
1374  0348 1e01          	ldw	x,(OFST-1,sp)
1375  034a 1c0001        	addw	x,#1
1376  034d 1f01          	ldw	(OFST-1,sp),x
1378  034f               L134:
1381  034f 1e01          	ldw	x,(OFST-1,sp)
1382  0351 72fb03        	addw	x,(OFST+1,sp)
1383  0354 7d            	tnz	(x)
1384  0355 26e9          	jrne	L524
1385                     ; 197 }
1388  0357 5b04          	addw	sp,#4
1389  0359 81            	ret
1440                     	switch	.const
1441  0006               _keypad_chars:
1442  0006 23            	dc.b	35
1443  0007 33            	dc.b	51
1444  0008 36            	dc.b	54
1445  0009 39            	dc.b	57
1446  000a 30            	dc.b	48
1447  000b 32            	dc.b	50
1448  000c 35            	dc.b	53
1449  000d 38            	dc.b	56
1450  000e 2a            	dc.b	42
1451  000f 31            	dc.b	49
1452  0010 34            	dc.b	52
1453  0011 37            	dc.b	55
1454                     	bsct
1455  000a               _encoder_done:
1456  000a 0000          	dc.w	0
1457  000c               _sb:
1458  000c 0000          	dc.w	0
1459  000e               _Input_Clock:
1460  000e 00            	dc.b	0
1461  000f               _isStored1:
1462  000f 0000          	dc.w	0
1463  0011               _isStored2:
1464  0011 0000          	dc.w	0
1506                     ; 101 void main(void) {
1507                     	switch	.text
1508  035a               _main:
1512                     ; 102     CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
1514  035a 4f            	clr	a
1515  035b cd0000        	call	_CLK_HSIPrescalerConfig
1517                     ; 103     GPIO_Init(SW_PIN, GPIO_MODE_IN_PU_NO_IT);
1519  035e 4b40          	push	#64
1520  0360 4b20          	push	#32
1521  0362 ae5014        	ldw	x,#20500
1522  0365 cd0000        	call	_GPIO_Init
1524  0368 85            	popw	x
1525                     ; 104     init_milis();
1527  0369 cd0000        	call	_init_milis
1529                     ; 105     Lcd_Begin();
1531  036c cd0201        	call	_Lcd_Begin
1533                     ; 106     Lcd_Clear();
1535  036f cd028f        	call	_Lcd_Clear
1537                     ; 107     Lcd_Set_Cursor(1, 1);
1539  0372 ae0101        	ldw	x,#257
1540  0375 cd0299        	call	_Lcd_Set_Cursor
1542                     ; 108     Lcd_Print_String("NACITAM PROGRAM");
1544  0378 ae01eb        	ldw	x,#L105
1545  037b adbc          	call	_Lcd_Print_String
1547                     ; 109 		Load_Animation();
1549  037d cd09e0        	call	_Load_Animation
1551  0380               L305:
1552                     ; 111         Lcd_Clear();
1554  0380 cd028f        	call	_Lcd_Clear
1556                     ; 112         Lcd_Set_Cursor(1, 4);
1558  0383 ae0104        	ldw	x,#260
1559  0386 cd0299        	call	_Lcd_Set_Cursor
1561                     ; 113         Lcd_Print_String("PRIJIMAC");
1563  0389 ae01e2        	ldw	x,#L705
1564  038c adab          	call	_Lcd_Print_String
1566                     ; 114         Lcd_Set_Cursor(2, 1);
1568  038e ae0201        	ldw	x,#513
1569  0391 cd0299        	call	_Lcd_Set_Cursor
1571                     ; 115         Lcd_Print_String("POMOCI TV TUNERU");
1573  0394 ae01d1        	ldw	x,#L115
1574  0397 ada0          	call	_Lcd_Print_String
1576                     ; 116         delay_ms(1500);
1578  0399 ae05dc        	ldw	x,#1500
1579  039c cd0000        	call	_delay_ms
1581                     ; 117         Lcd_Clear();
1583  039f cd028f        	call	_Lcd_Clear
1585                     ; 118         Lcd_Set_Cursor(1, 3);
1587  03a2 ae0103        	ldw	x,#259
1588  03a5 cd0299        	call	_Lcd_Set_Cursor
1590                     ; 119         Lcd_Print_String("PRO SPUSTENI");
1592  03a8 ae01c4        	ldw	x,#L315
1593  03ab ad8c          	call	_Lcd_Print_String
1595                     ; 120         Lcd_Set_Cursor(2, 1);
1597  03ad ae0201        	ldw	x,#513
1598  03b0 cd0299        	call	_Lcd_Set_Cursor
1600                     ; 121         Lcd_Print_String("ZMACKNI ENCODER");
1602  03b3 ae01b4        	ldw	x,#L515
1603  03b6 ad81          	call	_Lcd_Print_String
1605  03b8               L715:
1606                     ; 123             if (GPIO_ReadInputPin(SW_PIN) == RESET) {
1608  03b8 4b20          	push	#32
1609  03ba ae5014        	ldw	x,#20500
1610  03bd cd0000        	call	_GPIO_ReadInputPin
1612  03c0 5b01          	addw	sp,#1
1613  03c2 4d            	tnz	a
1614  03c3 26f3          	jrne	L715
1615                     ; 124                 delay_ms(200);
1617  03c5 ae00c8        	ldw	x,#200
1618  03c8 cd0000        	call	_delay_ms
1620                     ; 125                 Encoder_Mode();
1622  03cb ad09          	call	_Encoder_Mode
1624                     ; 126                 if (encoder_done) {
1626  03cd be0a          	ldw	x,_encoder_done
1627  03cf 27e7          	jreq	L715
1628                     ; 127                     encoder_done = 0;
1630  03d1 5f            	clrw	x
1631  03d2 bf0a          	ldw	_encoder_done,x
1632                     ; 128                     break;
1634  03d4 20aa          	jra	L305
1690                     ; 135 void Encoder_Mode(void) {
1691                     	switch	.text
1692  03d6               _Encoder_Mode:
1696                     ; 136 		GPIO_Init(RELAY_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
1698  03d6 4be0          	push	#224
1699  03d8 4b10          	push	#16
1700  03da ae5005        	ldw	x,#20485
1701  03dd cd0000        	call	_GPIO_Init
1703  03e0 85            	popw	x
1704                     ; 137     Lcd_Clear();
1706  03e1 cd028f        	call	_Lcd_Clear
1708                     ; 138 		GPIO_Init_Keypad();
1710  03e4 cd0a24        	call	_GPIO_Init_Keypad
1712                     ; 139     GPIO_Init_Encoder();
1714  03e7 cd0a0d        	call	_GPIO_Init_Encoder
1716                     ; 140 		GPIO_Init_Buttons();
1718  03ea cd0a3b        	call	_GPIO_Init_Buttons
1720                     ; 141     SW_I2C_init();
1722  03ed cd0000        	call	_SW_I2C_init
1724                     ; 142 		Lcd_Set_Cursor(1, 1);
1726  03f0 ae0101        	ldw	x,#257
1727  03f3 cd0299        	call	_Lcd_Set_Cursor
1729                     ; 143     Lcd_Print_String("VSTUP FREKVENCE:");
1731  03f6 ae01a3        	ldw	x,#L735
1732  03f9 cd0339        	call	_Lcd_Print_String
1734                     ; 144 		Lcd_Set_Cursor(2, 11);
1736  03fc ae020b        	ldw	x,#523
1737  03ff cd0299        	call	_Lcd_Set_Cursor
1739                     ; 145     Lcd_Print_String("MHz");
1741  0402 ae019f        	ldw	x,#L145
1742  0405 cd0339        	call	_Lcd_Print_String
1744                     ; 146 		skip_verification = 1; 
1746  0408 ae0001        	ldw	x,#1
1747  040b bf2c          	ldw	_skip_verification,x
1748                     ; 147 		Handle_Keypad_Input();
1750  040d cd11b5        	call	_Handle_Keypad_Input
1752                     ; 148 		Lcd_Set_Cursor(1, 1);
1754  0410 ae0101        	ldw	x,#257
1755  0413 cd0299        	call	_Lcd_Set_Cursor
1757                     ; 149     Lcd_Print_String("                ");
1759  0416 ae018e        	ldw	x,#L345
1760  0419 cd0339        	call	_Lcd_Print_String
1762                     ; 150 		Lcd_Set_Cursor(1, 1);
1764  041c ae0101        	ldw	x,#257
1765  041f cd0299        	call	_Lcd_Set_Cursor
1767                     ; 151     Lcd_Print_String("SUPERRX");
1769  0422 ae0186        	ldw	x,#L545
1770  0425 cd0339        	call	_Lcd_Print_String
1772                     ; 152 		Lcd_Set_Cursor(1, 13);
1774  0428 ae010d        	ldw	x,#269
1775  042b cd0299        	call	_Lcd_Set_Cursor
1777                     ; 153     Lcd_Print_String("S:--");
1779  042e ae0181        	ldw	x,#L745
1780  0431 cd0339        	call	_Lcd_Print_String
1782                     ; 154 		Lcd_Set_Cursor(1, 9);
1784  0434 ae0109        	ldw	x,#265
1785  0437 cd0299        	call	_Lcd_Set_Cursor
1787                     ; 155 		Lcd_Print_String("SB:N");
1789  043a ae017c        	ldw	x,#L155
1790  043d cd0339        	call	_Lcd_Print_String
1792                     ; 156 		GPIO_WriteHigh(RELAY_PIN);
1794  0440 4b10          	push	#16
1795  0442 ae5005        	ldw	x,#20485
1796  0445 cd0000        	call	_GPIO_WriteHigh
1798  0448 84            	pop	a
1799                     ; 158 		if (FLASH_ReadByte(EEPROM_ADDR_SLOT1_FLAG) == 1) {
1801  0449 ae4000        	ldw	x,#16384
1802  044c 89            	pushw	x
1803  044d ae0000        	ldw	x,#0
1804  0450 89            	pushw	x
1805  0451 cd0000        	call	_FLASH_ReadByte
1807  0454 5b04          	addw	sp,#4
1808  0456 a101          	cp	a,#1
1809  0458 2605          	jrne	L355
1810                     ; 159     isStored1 = 1;
1812  045a ae0001        	ldw	x,#1
1813  045d bf0f          	ldw	_isStored1,x
1814  045f               L355:
1815                     ; 161 		if (FLASH_ReadByte(EEPROM_ADDR_SLOT2_FLAG) == 1) {
1817  045f ae4004        	ldw	x,#16388
1818  0462 89            	pushw	x
1819  0463 ae0000        	ldw	x,#0
1820  0466 89            	pushw	x
1821  0467 cd0000        	call	_FLASH_ReadByte
1823  046a 5b04          	addw	sp,#4
1824  046c a101          	cp	a,#1
1825  046e 2605          	jrne	L755
1826                     ; 162     isStored2 = 1;
1828  0470 ae0001        	ldw	x,#1
1829  0473 bf11          	ldw	_isStored2,x
1830  0475               L755:
1831                     ; 166         if (GPIO_ReadInputPin(SW_PIN) == RESET) {
1833  0475 4b20          	push	#32
1834  0477 ae5014        	ldw	x,#20500
1835  047a cd0000        	call	_GPIO_ReadInputPin
1837  047d 5b01          	addw	sp,#1
1838  047f 4d            	tnz	a
1839  0480 2618          	jrne	L365
1840                     ; 167             encoder_done = 1;
1842  0482 ae0001        	ldw	x,#1
1843  0485 bf0a          	ldw	_encoder_done,x
1844                     ; 168 						Stand_By_Mode();
1846  0487 cd0fdf        	call	_Stand_By_Mode
1848                     ; 169 						GPIO_WriteLow(RELAY_PIN);
1850  048a 4b10          	push	#16
1851  048c ae5005        	ldw	x,#20485
1852  048f cd0000        	call	_GPIO_WriteLow
1854  0492 84            	pop	a
1855                     ; 170             delay_ms(200);
1857  0493 ae00c8        	ldw	x,#200
1858  0496 cd0000        	call	_delay_ms
1860                     ; 171             break;
1861                     ; 213 }
1864  0499 81            	ret
1865  049a               L365:
1866                     ; 173 				if (GPIO_ReadInputPin(BTN1_PIN) == RESET) {  
1868  049a 4b01          	push	#1
1869  049c ae5005        	ldw	x,#20485
1870  049f cd0000        	call	_GPIO_ReadInputPin
1872  04a2 5b01          	addw	sp,#1
1873  04a4 4d            	tnz	a
1874  04a5 264d          	jrne	L565
1875                     ; 174             Read_From_Tuner();
1877  04a7 cd0903        	call	_Read_From_Tuner
1879                     ; 175 						delay_ms(2000);
1881  04aa ae07d0        	ldw	x,#2000
1882  04ad cd0000        	call	_delay_ms
1884                     ; 176 						Lcd_Clear();
1886  04b0 cd028f        	call	_Lcd_Clear
1888                     ; 177 						Lcd_Set_Cursor(1, 1);
1890  04b3 ae0101        	ldw	x,#257
1891  04b6 cd0299        	call	_Lcd_Set_Cursor
1893                     ; 178 						Lcd_Print_String("SUPERRX");
1895  04b9 ae0186        	ldw	x,#L545
1896  04bc cd0339        	call	_Lcd_Print_String
1898                     ; 179 						Lcd_Set_Cursor(2, 11);
1900  04bf ae020b        	ldw	x,#523
1901  04c2 cd0299        	call	_Lcd_Set_Cursor
1903                     ; 180 						Lcd_Print_String("MHz");
1905  04c5 ae019f        	ldw	x,#L145
1906  04c8 cd0339        	call	_Lcd_Print_String
1908                     ; 181 						Lcd_Set_Cursor(1, 13);
1910  04cb ae010d        	ldw	x,#269
1911  04ce cd0299        	call	_Lcd_Set_Cursor
1913                     ; 182 						Lcd_Print_String("S:");
1915  04d1 ae0179        	ldw	x,#L765
1916  04d4 cd0339        	call	_Lcd_Print_String
1918                     ; 183 						Lcd_Set_Cursor(1, 9);
1920  04d7 ae0109        	ldw	x,#265
1921  04da cd0299        	call	_Lcd_Set_Cursor
1923                     ; 184 						Lcd_Print_String("SB:");
1925  04dd ae0175        	ldw	x,#L175
1926  04e0 cd0339        	call	_Lcd_Print_String
1928                     ; 185 						Control_Byte_Settings();
1930  04e3 cd0a68        	call	_Control_Byte_Settings
1932                     ; 186 						force_lcd_update = 1;
1934  04e6 ae0001        	ldw	x,#1
1935  04e9 bf00          	ldw	_force_lcd_update,x
1936                     ; 187 						Radio_Frequency();
1938  04eb cd0f60        	call	_Radio_Frequency
1940                     ; 188 						Print_Frequency();
1942  04ee cd0ff5        	call	_Print_Frequency
1944                     ; 189 						LCD_Dec_Fix();
1946  04f1 cd0b3f        	call	_LCD_Dec_Fix
1948  04f4               L565:
1949                     ; 191 				if (GPIO_ReadInputPin(BTN2_PIN) == RESET) {  // Toggle Weak Signal Booster (WSB)
1951  04f4 4b02          	push	#2
1952  04f6 ae5005        	ldw	x,#20485
1953  04f9 cd0000        	call	_GPIO_ReadInputPin
1955  04fc 5b01          	addw	sp,#1
1956  04fe 4d            	tnz	a
1957  04ff 2610          	jrne	L375
1958                     ; 192 						sb++;
1960  0501 be0c          	ldw	x,_sb
1961  0503 1c0001        	addw	x,#1
1962  0506 bf0c          	ldw	_sb,x
1963                     ; 193 						Control_Byte_Settings();
1965  0508 cd0a68        	call	_Control_Byte_Settings
1967                     ; 194 						delay_ms(200);  // Debounce delay
1969  050b ae00c8        	ldw	x,#200
1970  050e cd0000        	call	_delay_ms
1972  0511               L375:
1973                     ; 196 				if (GPIO_ReadInputPin(BTN3_PIN) == RESET) {
1975  0511 4b04          	push	#4
1976  0513 ae5005        	ldw	x,#20485
1977  0516 cd0000        	call	_GPIO_ReadInputPin
1979  0519 5b01          	addw	sp,#1
1980  051b 4d            	tnz	a
1981  051c 2609          	jrne	L575
1982                     ; 197 						Stored_In_Memory1();
1984  051e cd0657        	call	_Stored_In_Memory1
1986                     ; 198 						delay_ms(200);
1988  0521 ae00c8        	ldw	x,#200
1989  0524 cd0000        	call	_delay_ms
1991  0527               L575:
1992                     ; 200 				if (GPIO_ReadInputPin(BTN4_PIN) == RESET) {
1994  0527 4b08          	push	#8
1995  0529 ae5005        	ldw	x,#20485
1996  052c cd0000        	call	_GPIO_ReadInputPin
1998  052f 5b01          	addw	sp,#1
1999  0531 4d            	tnz	a
2000  0532 2609          	jrne	L775
2001                     ; 201 						Stored_In_Memory2();
2003  0534 cd078d        	call	_Stored_In_Memory2
2005                     ; 202 						delay_ms(200);
2007  0537 ae00c8        	ldw	x,#200
2008  053a cd0000        	call	_delay_ms
2010  053d               L775:
2011                     ; 204         Encoder_Read();
2013  053d cd0aaa        	call	_Encoder_Read
2015                     ; 205         Update_Frequency();
2017  0540 cd1051        	call	_Update_Frequency
2019                     ; 206         Print_Frequency();
2021  0543 cd0ff5        	call	_Print_Frequency
2023                     ; 207         Additional_Info();
2025  0546 cd0c00        	call	_Additional_Info
2027                     ; 208         Frequency_Limits();
2029  0549 cd10a1        	call	_Frequency_Limits
2031                     ; 209         Radio_Frequency();
2033  054c cd0f60        	call	_Radio_Frequency
2035                     ; 210 				Handle_Keypad_Input();
2037  054f cd11b5        	call	_Handle_Keypad_Input
2039                     ; 211 				Update_Memory_Indicator();
2041  0552 cd08c2        	call	_Update_Memory_Indicator
2044  0555 ac750475      	jpf	L755
2102                     ; 215 void EEPROM_Store_Slot(uint8_t slot, uint16_t f1, int8_t f2) {
2103                     	switch	.text
2104  0559               _EEPROM_Store_Slot:
2106  0559 88            	push	a
2107       00000000      OFST:	set	0
2110                     ; 216     if (slot == 1) {
2112  055a a101          	cp	a,#1
2113  055c 2611          	jrne	L726
2114                     ; 217         addr_flag = EEPROM_ADDR_SLOT1_FLAG;
2116  055e ae4000        	ldw	x,#16384
2117  0561 bf04          	ldw	_addr_flag,x
2118                     ; 218         addr_frec1 = EEPROM_ADDR_SLOT1_FREC1;
2120  0563 ae4001        	ldw	x,#16385
2121  0566 bf02          	ldw	_addr_frec1,x
2122                     ; 219         addr_frec2 = EEPROM_ADDR_SLOT1_FREC2;
2124  0568 ae4003        	ldw	x,#16387
2125  056b bf00          	ldw	_addr_frec2,x
2127  056d 200f          	jra	L136
2128  056f               L726:
2129                     ; 221         addr_flag = EEPROM_ADDR_SLOT2_FLAG;
2131  056f ae4004        	ldw	x,#16388
2132  0572 bf04          	ldw	_addr_flag,x
2133                     ; 222         addr_frec1 = EEPROM_ADDR_SLOT2_FREC1;
2135  0574 ae4005        	ldw	x,#16389
2136  0577 bf02          	ldw	_addr_frec1,x
2137                     ; 223         addr_frec2 = EEPROM_ADDR_SLOT2_FREC2;
2139  0579 ae4007        	ldw	x,#16391
2140  057c bf00          	ldw	_addr_frec2,x
2141  057e               L136:
2142                     ; 226     FLASH_Unlock(FLASH_MEMTYPE_DATA);
2144  057e a6f7          	ld	a,#247
2145  0580 cd0000        	call	_FLASH_Unlock
2147                     ; 227     FLASH_ProgramByte(addr_frec1, f1 & 0xFF);
2149  0583 7b05          	ld	a,(OFST+5,sp)
2150  0585 a4ff          	and	a,#255
2151  0587 88            	push	a
2152  0588 be02          	ldw	x,_addr_frec1
2153  058a cd0000        	call	c_uitolx
2155  058d be02          	ldw	x,c_lreg+2
2156  058f 89            	pushw	x
2157  0590 be00          	ldw	x,c_lreg
2158  0592 89            	pushw	x
2159  0593 cd0000        	call	_FLASH_ProgramByte
2161  0596 5b05          	addw	sp,#5
2162                     ; 228     FLASH_ProgramByte(addr_frec1 + 1, (f1 >> 8) & 0xFF);
2164  0598 7b04          	ld	a,(OFST+4,sp)
2165  059a 88            	push	a
2166  059b be02          	ldw	x,_addr_frec1
2167  059d 5c            	incw	x
2168  059e cd0000        	call	c_uitolx
2170  05a1 be02          	ldw	x,c_lreg+2
2171  05a3 89            	pushw	x
2172  05a4 be00          	ldw	x,c_lreg
2173  05a6 89            	pushw	x
2174  05a7 cd0000        	call	_FLASH_ProgramByte
2176  05aa 5b05          	addw	sp,#5
2177                     ; 229     FLASH_ProgramByte(addr_frec2, f2);
2179  05ac 7b06          	ld	a,(OFST+6,sp)
2180  05ae 88            	push	a
2181  05af be00          	ldw	x,_addr_frec2
2182  05b1 cd0000        	call	c_uitolx
2184  05b4 be02          	ldw	x,c_lreg+2
2185  05b6 89            	pushw	x
2186  05b7 be00          	ldw	x,c_lreg
2187  05b9 89            	pushw	x
2188  05ba cd0000        	call	_FLASH_ProgramByte
2190  05bd 5b05          	addw	sp,#5
2191                     ; 230     FLASH_ProgramByte(addr_flag, 1);
2193  05bf 4b01          	push	#1
2194  05c1 be04          	ldw	x,_addr_flag
2195  05c3 cd0000        	call	c_uitolx
2197  05c6 be02          	ldw	x,c_lreg+2
2198  05c8 89            	pushw	x
2199  05c9 be00          	ldw	x,c_lreg
2200  05cb 89            	pushw	x
2201  05cc cd0000        	call	_FLASH_ProgramByte
2203  05cf 5b05          	addw	sp,#5
2204                     ; 231     FLASH_Lock(FLASH_MEMTYPE_DATA);
2206  05d1 a6f7          	ld	a,#247
2207  05d3 cd0000        	call	_FLASH_Lock
2209                     ; 233 }
2212  05d6 84            	pop	a
2213  05d7 81            	ret
2271                     ; 235 uint8_t EEPROM_Load_Slot(uint8_t slot, uint16_t* f1, int8_t* f2) {
2272                     	switch	.text
2273  05d8               _EEPROM_Load_Slot:
2275  05d8 88            	push	a
2276       00000000      OFST:	set	0
2279                     ; 236     if (slot == 1) {
2281  05d9 a101          	cp	a,#1
2282  05db 2611          	jrne	L166
2283                     ; 237         addr_flag = EEPROM_ADDR_SLOT1_FLAG;
2285  05dd ae4000        	ldw	x,#16384
2286  05e0 bf04          	ldw	_addr_flag,x
2287                     ; 238         addr_frec1 = EEPROM_ADDR_SLOT1_FREC1;
2289  05e2 ae4001        	ldw	x,#16385
2290  05e5 bf02          	ldw	_addr_frec1,x
2291                     ; 239         addr_frec2 = EEPROM_ADDR_SLOT1_FREC2;
2293  05e7 ae4003        	ldw	x,#16387
2294  05ea bf00          	ldw	_addr_frec2,x
2296  05ec 200f          	jra	L366
2297  05ee               L166:
2298                     ; 241         addr_flag = EEPROM_ADDR_SLOT2_FLAG;
2300  05ee ae4004        	ldw	x,#16388
2301  05f1 bf04          	ldw	_addr_flag,x
2302                     ; 242         addr_frec1 = EEPROM_ADDR_SLOT2_FREC1;
2304  05f3 ae4005        	ldw	x,#16389
2305  05f6 bf02          	ldw	_addr_frec1,x
2306                     ; 243         addr_frec2 = EEPROM_ADDR_SLOT2_FREC2;
2308  05f8 ae4007        	ldw	x,#16391
2309  05fb bf00          	ldw	_addr_frec2,x
2310  05fd               L366:
2311                     ; 245     if (FLASH_ReadByte(addr_flag) != 1) {
2313  05fd be04          	ldw	x,_addr_flag
2314  05ff cd0000        	call	c_uitolx
2316  0602 be02          	ldw	x,c_lreg+2
2317  0604 89            	pushw	x
2318  0605 be00          	ldw	x,c_lreg
2319  0607 89            	pushw	x
2320  0608 cd0000        	call	_FLASH_ReadByte
2322  060b 5b04          	addw	sp,#4
2323  060d a101          	cp	a,#1
2324  060f 2704          	jreq	L566
2325                     ; 246         return 0; 
2327  0611 4f            	clr	a
2330  0612 5b01          	addw	sp,#1
2331  0614 81            	ret
2332  0615               L566:
2333                     ; 249     *f1 = FLASH_ReadByte(addr_frec1) | (FLASH_ReadByte(addr_frec1 + 1) << 8);
2335  0615 be02          	ldw	x,_addr_frec1
2336  0617 5c            	incw	x
2337  0618 cd0000        	call	c_uitolx
2339  061b be02          	ldw	x,c_lreg+2
2340  061d 89            	pushw	x
2341  061e be00          	ldw	x,c_lreg
2342  0620 89            	pushw	x
2343  0621 cd0000        	call	_FLASH_ReadByte
2345  0624 5b04          	addw	sp,#4
2346  0626 5f            	clrw	x
2347  0627 97            	ld	xl,a
2348  0628 89            	pushw	x
2349  0629 be02          	ldw	x,_addr_frec1
2350  062b cd0000        	call	c_uitolx
2352  062e be02          	ldw	x,c_lreg+2
2353  0630 89            	pushw	x
2354  0631 be00          	ldw	x,c_lreg
2355  0633 89            	pushw	x
2356  0634 cd0000        	call	_FLASH_ReadByte
2358  0637 5b04          	addw	sp,#4
2359  0639 85            	popw	x
2360  063a 02            	rlwa	x,a
2361  063b 1604          	ldw	y,(OFST+4,sp)
2362  063d 90ff          	ldw	(y),x
2363                     ; 250     *f2 = FLASH_ReadByte(addr_frec2);
2365  063f be00          	ldw	x,_addr_frec2
2366  0641 cd0000        	call	c_uitolx
2368  0644 be02          	ldw	x,c_lreg+2
2369  0646 89            	pushw	x
2370  0647 be00          	ldw	x,c_lreg
2371  0649 89            	pushw	x
2372  064a cd0000        	call	_FLASH_ReadByte
2374  064d 5b04          	addw	sp,#4
2375  064f 1e06          	ldw	x,(OFST+6,sp)
2376  0651 f7            	ld	(x),a
2377                     ; 251     return 1;
2379  0652 a601          	ld	a,#1
2382  0654 5b01          	addw	sp,#1
2383  0656 81            	ret
2424                     ; 254 void Stored_In_Memory1() {
2425                     	switch	.text
2426  0657               _Stored_In_Memory1:
2428  0657 5204          	subw	sp,#4
2429       00000004      OFST:	set	4
2432                     ; 255     if (isStored1==0) {
2434  0659 be0f          	ldw	x,_isStored1
2435  065b 265e          	jrne	L776
2436                     ; 256         isStored1 = 1;
2438  065d ae0001        	ldw	x,#1
2439  0660 bf0f          	ldw	_isStored1,x
2440                     ; 257 				EEPROM_Store_Slot(1, frec1, frec2);
2442  0662 3b0027        	push	_frec2
2443  0665 be25          	ldw	x,_frec1
2444  0667 89            	pushw	x
2445  0668 a601          	ld	a,#1
2446  066a cd0559        	call	_EEPROM_Store_Slot
2448  066d 5b03          	addw	sp,#3
2449                     ; 258 				Lcd_Set_Cursor(1, 1);
2451  066f ae0101        	ldw	x,#257
2452  0672 cd0299        	call	_Lcd_Set_Cursor
2454                     ; 259 				Lcd_Print_String("UKLADAM FREKV. 1");
2456  0675 ae0164        	ldw	x,#L107
2457  0678 cd0339        	call	_Lcd_Print_String
2459                     ; 260 				delay_ms(1500);
2461  067b ae05dc        	ldw	x,#1500
2462  067e cd0000        	call	_delay_ms
2464                     ; 261 				Lcd_Set_Cursor(1, 8);
2466  0681 ae0108        	ldw	x,#264
2467  0684 cd0299        	call	_Lcd_Set_Cursor
2469                     ; 262 				Lcd_Print_String(" ");
2471  0687 ae01fb        	ldw	x,#L112
2472  068a cd0339        	call	_Lcd_Print_String
2474                     ; 263 				Lcd_Set_Cursor(1, 1);
2476  068d ae0101        	ldw	x,#257
2477  0690 cd0299        	call	_Lcd_Set_Cursor
2479                     ; 264 				Lcd_Print_String("SUPERRX");
2481  0693 ae0186        	ldw	x,#L545
2482  0696 cd0339        	call	_Lcd_Print_String
2484                     ; 265 				Lcd_Set_Cursor(1, 13);
2486  0699 ae010d        	ldw	x,#269
2487  069c cd0299        	call	_Lcd_Set_Cursor
2489                     ; 266 				Lcd_Print_String("S:");
2491  069f ae0179        	ldw	x,#L765
2492  06a2 cd0339        	call	_Lcd_Print_String
2494                     ; 267 				Lcd_Set_Cursor(1, 9);
2496  06a5 ae0109        	ldw	x,#265
2497  06a8 cd0299        	call	_Lcd_Set_Cursor
2499                     ; 268 				Lcd_Print_String("SB:");
2501  06ab ae0175        	ldw	x,#L175
2502  06ae cd0339        	call	_Lcd_Print_String
2504                     ; 269 				Control_Byte_Settings();
2506  06b1 cd0a68        	call	_Control_Byte_Settings
2508                     ; 270 				Update_Memory_Indicator();
2510  06b4 cd08c2        	call	_Update_Memory_Indicator
2513  06b7 ac8a078a      	jpf	L307
2514  06bb               L776:
2515                     ; 272 				EEPROM_Load_Slot(1, &frec1, &frec2);
2517  06bb ae0027        	ldw	x,#_frec2
2518  06be 89            	pushw	x
2519  06bf ae0025        	ldw	x,#_frec1
2520  06c2 89            	pushw	x
2521  06c3 a601          	ld	a,#1
2522  06c5 cd05d8        	call	_EEPROM_Load_Slot
2524  06c8 5b04          	addw	sp,#4
2525                     ; 273 				frec = frec1 + frec2 / 10.0f;//korekce frekvence 
2527  06ca be25          	ldw	x,_frec1
2528  06cc cd0000        	call	c_uitof
2530  06cf 96            	ldw	x,sp
2531  06d0 1c0001        	addw	x,#OFST-3
2532  06d3 cd0000        	call	c_rtol
2535  06d6 5f            	clrw	x
2536  06d7 b627          	ld	a,_frec2
2537  06d9 2a01          	jrpl	L26
2538  06db 53            	cplw	x
2539  06dc               L26:
2540  06dc 97            	ld	xl,a
2541  06dd cd0000        	call	c_itof
2543  06e0 ae0160        	ldw	x,#L117
2544  06e3 cd0000        	call	c_fdiv
2546  06e6 96            	ldw	x,sp
2547  06e7 1c0001        	addw	x,#OFST-3
2548  06ea cd0000        	call	c_fadd
2550  06ed ae0021        	ldw	x,#_frec
2551  06f0 cd0000        	call	c_rtol
2553                     ; 274         isStored1 = 0; 
2555  06f3 5f            	clrw	x
2556  06f4 bf0f          	ldw	_isStored1,x
2557                     ; 276 				FLASH_Unlock(FLASH_MEMTYPE_DATA);
2559  06f6 a6f7          	ld	a,#247
2560  06f8 cd0000        	call	_FLASH_Unlock
2562                     ; 277 				FLASH_EraseByte(EEPROM_ADDR_SLOT1_FLAG);
2564  06fb ae4000        	ldw	x,#16384
2565  06fe 89            	pushw	x
2566  06ff ae0000        	ldw	x,#0
2567  0702 89            	pushw	x
2568  0703 cd0000        	call	_FLASH_EraseByte
2570  0706 5b04          	addw	sp,#4
2571                     ; 278 				FLASH_EraseByte(EEPROM_ADDR_SLOT1_FREC1);
2573  0708 ae4001        	ldw	x,#16385
2574  070b 89            	pushw	x
2575  070c ae0000        	ldw	x,#0
2576  070f 89            	pushw	x
2577  0710 cd0000        	call	_FLASH_EraseByte
2579  0713 5b04          	addw	sp,#4
2580                     ; 279 				FLASH_EraseByte(EEPROM_ADDR_SLOT1_FREC1 + 1);
2582  0715 ae4002        	ldw	x,#16386
2583  0718 89            	pushw	x
2584  0719 ae0000        	ldw	x,#0
2585  071c 89            	pushw	x
2586  071d cd0000        	call	_FLASH_EraseByte
2588  0720 5b04          	addw	sp,#4
2589                     ; 280 				FLASH_EraseByte(EEPROM_ADDR_SLOT1_FREC2);
2591  0722 ae4003        	ldw	x,#16387
2592  0725 89            	pushw	x
2593  0726 ae0000        	ldw	x,#0
2594  0729 89            	pushw	x
2595  072a cd0000        	call	_FLASH_EraseByte
2597  072d 5b04          	addw	sp,#4
2598                     ; 281 				FLASH_Lock(FLASH_MEMTYPE_DATA);
2600  072f a6f7          	ld	a,#247
2601  0731 cd0000        	call	_FLASH_Lock
2603                     ; 283 				Lcd_Set_Cursor(1, 1);
2605  0734 ae0101        	ldw	x,#257
2606  0737 cd0299        	call	_Lcd_Set_Cursor
2608                     ; 284 				Lcd_Print_String("NACITAM FREKV. 1");
2610  073a ae014f        	ldw	x,#L517
2611  073d cd0339        	call	_Lcd_Print_String
2613                     ; 285 				delay_ms(1500);
2615  0740 ae05dc        	ldw	x,#1500
2616  0743 cd0000        	call	_delay_ms
2618                     ; 286 				Lcd_Set_Cursor(1, 8);
2620  0746 ae0108        	ldw	x,#264
2621  0749 cd0299        	call	_Lcd_Set_Cursor
2623                     ; 287 				Lcd_Print_String(" ");
2625  074c ae01fb        	ldw	x,#L112
2626  074f cd0339        	call	_Lcd_Print_String
2628                     ; 288 				Lcd_Set_Cursor(1, 1);
2630  0752 ae0101        	ldw	x,#257
2631  0755 cd0299        	call	_Lcd_Set_Cursor
2633                     ; 289 				Lcd_Print_String("SUPERRX");
2635  0758 ae0186        	ldw	x,#L545
2636  075b cd0339        	call	_Lcd_Print_String
2638                     ; 290 				Lcd_Set_Cursor(1, 13);
2640  075e ae010d        	ldw	x,#269
2641  0761 cd0299        	call	_Lcd_Set_Cursor
2643                     ; 291 				Lcd_Print_String("S:");
2645  0764 ae0179        	ldw	x,#L765
2646  0767 cd0339        	call	_Lcd_Print_String
2648                     ; 292 				Lcd_Set_Cursor(1, 9);
2650  076a ae0109        	ldw	x,#265
2651  076d cd0299        	call	_Lcd_Set_Cursor
2653                     ; 293 				Lcd_Print_String("SB:");
2655  0770 ae0175        	ldw	x,#L175
2656  0773 cd0339        	call	_Lcd_Print_String
2658                     ; 294 				Control_Byte_Settings();
2660  0776 cd0a68        	call	_Control_Byte_Settings
2662                     ; 295 				Update_Memory_Indicator();
2664  0779 cd08c2        	call	_Update_Memory_Indicator
2666                     ; 296 				force_lcd_update = 1;
2668  077c ae0001        	ldw	x,#1
2669  077f bf00          	ldw	_force_lcd_update,x
2670                     ; 297 				Radio_Frequency();
2672  0781 cd0f60        	call	_Radio_Frequency
2674                     ; 298 				Print_Frequency();
2676  0784 cd0ff5        	call	_Print_Frequency
2678                     ; 299 				LCD_Dec_Fix();
2680  0787 cd0b3f        	call	_LCD_Dec_Fix
2682  078a               L307:
2683                     ; 301 }
2686  078a 5b04          	addw	sp,#4
2687  078c 81            	ret
2728                     ; 302 void Stored_In_Memory2() {
2729                     	switch	.text
2730  078d               _Stored_In_Memory2:
2732  078d 5204          	subw	sp,#4
2733       00000004      OFST:	set	4
2736                     ; 303     if (isStored2==0) {
2738  078f be11          	ldw	x,_isStored2
2739  0791 265e          	jrne	L727
2740                     ; 304         isStored2 = 1;
2742  0793 ae0001        	ldw	x,#1
2743  0796 bf11          	ldw	_isStored2,x
2744                     ; 305 				EEPROM_Store_Slot(2, frec1, frec2);
2746  0798 3b0027        	push	_frec2
2747  079b be25          	ldw	x,_frec1
2748  079d 89            	pushw	x
2749  079e a602          	ld	a,#2
2750  07a0 cd0559        	call	_EEPROM_Store_Slot
2752  07a3 5b03          	addw	sp,#3
2753                     ; 306 				Lcd_Set_Cursor(1, 1);
2755  07a5 ae0101        	ldw	x,#257
2756  07a8 cd0299        	call	_Lcd_Set_Cursor
2758                     ; 307 				Lcd_Print_String("UKLADAM FREKV. 2");
2760  07ab ae013e        	ldw	x,#L137
2761  07ae cd0339        	call	_Lcd_Print_String
2763                     ; 308 				delay_ms(1500);
2765  07b1 ae05dc        	ldw	x,#1500
2766  07b4 cd0000        	call	_delay_ms
2768                     ; 309 				Lcd_Set_Cursor(1, 8);
2770  07b7 ae0108        	ldw	x,#264
2771  07ba cd0299        	call	_Lcd_Set_Cursor
2773                     ; 310 				Lcd_Print_String(" ");
2775  07bd ae01fb        	ldw	x,#L112
2776  07c0 cd0339        	call	_Lcd_Print_String
2778                     ; 311 				Lcd_Set_Cursor(1, 1);
2780  07c3 ae0101        	ldw	x,#257
2781  07c6 cd0299        	call	_Lcd_Set_Cursor
2783                     ; 312 				Lcd_Print_String("SUPERRX");
2785  07c9 ae0186        	ldw	x,#L545
2786  07cc cd0339        	call	_Lcd_Print_String
2788                     ; 313 				Lcd_Set_Cursor(1, 13);
2790  07cf ae010d        	ldw	x,#269
2791  07d2 cd0299        	call	_Lcd_Set_Cursor
2793                     ; 314 				Lcd_Print_String("S:");
2795  07d5 ae0179        	ldw	x,#L765
2796  07d8 cd0339        	call	_Lcd_Print_String
2798                     ; 315 				Lcd_Set_Cursor(1, 9);
2800  07db ae0109        	ldw	x,#265
2801  07de cd0299        	call	_Lcd_Set_Cursor
2803                     ; 316 				Lcd_Print_String("SB:");
2805  07e1 ae0175        	ldw	x,#L175
2806  07e4 cd0339        	call	_Lcd_Print_String
2808                     ; 317 				Control_Byte_Settings();
2810  07e7 cd0a68        	call	_Control_Byte_Settings
2812                     ; 318 				Update_Memory_Indicator();
2814  07ea cd08c2        	call	_Update_Memory_Indicator
2817  07ed acbf08bf      	jpf	L337
2818  07f1               L727:
2819                     ; 320 				EEPROM_Load_Slot(2, &frec1, &frec2);
2821  07f1 ae0027        	ldw	x,#_frec2
2822  07f4 89            	pushw	x
2823  07f5 ae0025        	ldw	x,#_frec1
2824  07f8 89            	pushw	x
2825  07f9 a602          	ld	a,#2
2826  07fb cd05d8        	call	_EEPROM_Load_Slot
2828  07fe 5b04          	addw	sp,#4
2829                     ; 321 				frec = frec1 + frec2 / 10.0f;//korekce frekvence 
2831  0800 be25          	ldw	x,_frec1
2832  0802 cd0000        	call	c_uitof
2834  0805 96            	ldw	x,sp
2835  0806 1c0001        	addw	x,#OFST-3
2836  0809 cd0000        	call	c_rtol
2839  080c 5f            	clrw	x
2840  080d b627          	ld	a,_frec2
2841  080f 2a01          	jrpl	L66
2842  0811 53            	cplw	x
2843  0812               L66:
2844  0812 97            	ld	xl,a
2845  0813 cd0000        	call	c_itof
2847  0816 ae0160        	ldw	x,#L117
2848  0819 cd0000        	call	c_fdiv
2850  081c 96            	ldw	x,sp
2851  081d 1c0001        	addw	x,#OFST-3
2852  0820 cd0000        	call	c_fadd
2854  0823 ae0021        	ldw	x,#_frec
2855  0826 cd0000        	call	c_rtol
2857                     ; 322         isStored2 = 0; 
2859  0829 5f            	clrw	x
2860  082a bf11          	ldw	_isStored2,x
2861                     ; 324 				FLASH_Unlock(FLASH_MEMTYPE_DATA);
2863  082c a6f7          	ld	a,#247
2864  082e cd0000        	call	_FLASH_Unlock
2866                     ; 325 				FLASH_EraseByte(EEPROM_ADDR_SLOT2_FLAG);
2868  0831 ae4004        	ldw	x,#16388
2869  0834 89            	pushw	x
2870  0835 ae0000        	ldw	x,#0
2871  0838 89            	pushw	x
2872  0839 cd0000        	call	_FLASH_EraseByte
2874  083c 5b04          	addw	sp,#4
2875                     ; 326 				FLASH_EraseByte(EEPROM_ADDR_SLOT2_FREC1);
2877  083e ae4005        	ldw	x,#16389
2878  0841 89            	pushw	x
2879  0842 ae0000        	ldw	x,#0
2880  0845 89            	pushw	x
2881  0846 cd0000        	call	_FLASH_EraseByte
2883  0849 5b04          	addw	sp,#4
2884                     ; 327 				FLASH_EraseByte(EEPROM_ADDR_SLOT2_FREC1 + 1);
2886  084b ae4006        	ldw	x,#16390
2887  084e 89            	pushw	x
2888  084f ae0000        	ldw	x,#0
2889  0852 89            	pushw	x
2890  0853 cd0000        	call	_FLASH_EraseByte
2892  0856 5b04          	addw	sp,#4
2893                     ; 328 				FLASH_EraseByte(EEPROM_ADDR_SLOT2_FREC2);
2895  0858 ae4007        	ldw	x,#16391
2896  085b 89            	pushw	x
2897  085c ae0000        	ldw	x,#0
2898  085f 89            	pushw	x
2899  0860 cd0000        	call	_FLASH_EraseByte
2901  0863 5b04          	addw	sp,#4
2902                     ; 329 				FLASH_Lock(FLASH_MEMTYPE_DATA);
2904  0865 a6f7          	ld	a,#247
2905  0867 cd0000        	call	_FLASH_Lock
2907                     ; 331 				Lcd_Set_Cursor(1, 1);
2909  086a ae0101        	ldw	x,#257
2910  086d cd0299        	call	_Lcd_Set_Cursor
2912                     ; 332 				Lcd_Print_String("NACITAM FREKV. 2");
2914  0870 ae012d        	ldw	x,#L537
2915  0873 cd0339        	call	_Lcd_Print_String
2917                     ; 333 				delay_ms(1500);
2919  0876 ae05dc        	ldw	x,#1500
2920  0879 cd0000        	call	_delay_ms
2922                     ; 334 				Lcd_Set_Cursor(1, 8);
2924  087c ae0108        	ldw	x,#264
2925  087f cd0299        	call	_Lcd_Set_Cursor
2927                     ; 335 				Lcd_Print_String(" ");
2929  0882 ae01fb        	ldw	x,#L112
2930  0885 cd0339        	call	_Lcd_Print_String
2932                     ; 336 				Lcd_Set_Cursor(1, 1);
2934  0888 ae0101        	ldw	x,#257
2935  088b cd0299        	call	_Lcd_Set_Cursor
2937                     ; 337 				Lcd_Print_String("SUPERRX");
2939  088e ae0186        	ldw	x,#L545
2940  0891 cd0339        	call	_Lcd_Print_String
2942                     ; 338 				Lcd_Set_Cursor(1, 13);
2944  0894 ae010d        	ldw	x,#269
2945  0897 cd0299        	call	_Lcd_Set_Cursor
2947                     ; 339 				Lcd_Print_String("S:");
2949  089a ae0179        	ldw	x,#L765
2950  089d cd0339        	call	_Lcd_Print_String
2952                     ; 340 				Lcd_Set_Cursor(1, 9);
2954  08a0 ae0109        	ldw	x,#265
2955  08a3 cd0299        	call	_Lcd_Set_Cursor
2957                     ; 341 				Lcd_Print_String("SB:");
2959  08a6 ae0175        	ldw	x,#L175
2960  08a9 cd0339        	call	_Lcd_Print_String
2962                     ; 342 				Control_Byte_Settings();
2964  08ac cd0a68        	call	_Control_Byte_Settings
2966                     ; 343 				Update_Memory_Indicator();
2968  08af ad11          	call	_Update_Memory_Indicator
2970                     ; 344 				force_lcd_update = 1;
2972  08b1 ae0001        	ldw	x,#1
2973  08b4 bf00          	ldw	_force_lcd_update,x
2974                     ; 345 				Radio_Frequency();
2976  08b6 cd0f60        	call	_Radio_Frequency
2978                     ; 346 				Print_Frequency();
2980  08b9 cd0ff5        	call	_Print_Frequency
2982                     ; 347 				LCD_Dec_Fix();
2984  08bc cd0b3f        	call	_LCD_Dec_Fix
2986  08bf               L337:
2987                     ; 349 }
2990  08bf 5b04          	addw	sp,#4
2991  08c1 81            	ret
3019                     ; 351 void Update_Memory_Indicator(void) {
3020                     	switch	.text
3021  08c2               _Update_Memory_Indicator:
3025                     ; 352 		Lcd_Set_Cursor(1, 15);
3027  08c2 ae010f        	ldw	x,#271
3028  08c5 cd0299        	call	_Lcd_Set_Cursor
3030                     ; 353     if (isStored1==1 && isStored2==1) {
3032  08c8 be0f          	ldw	x,_isStored1
3033  08ca a30001        	cpw	x,#1
3034  08cd 260f          	jrne	L747
3036  08cf be11          	ldw	x,_isStored2
3037  08d1 a30001        	cpw	x,#1
3038  08d4 2608          	jrne	L747
3039                     ; 354         Lcd_Print_String("12");
3041  08d6 ae012a        	ldw	x,#L157
3042  08d9 cd0339        	call	_Lcd_Print_String
3045  08dc 2024          	jra	L357
3046  08de               L747:
3047                     ; 355     } else if (isStored1==1) {
3049  08de be0f          	ldw	x,_isStored1
3050  08e0 a30001        	cpw	x,#1
3051  08e3 2608          	jrne	L557
3052                     ; 356         Lcd_Print_String("1-");
3054  08e5 ae0127        	ldw	x,#L757
3055  08e8 cd0339        	call	_Lcd_Print_String
3058  08eb 2015          	jra	L357
3059  08ed               L557:
3060                     ; 357     } else if (isStored2==1) {
3062  08ed be11          	ldw	x,_isStored2
3063  08ef a30001        	cpw	x,#1
3064  08f2 2608          	jrne	L367
3065                     ; 358         Lcd_Print_String("-2");
3067  08f4 ae0124        	ldw	x,#L567
3068  08f7 cd0339        	call	_Lcd_Print_String
3071  08fa 2006          	jra	L357
3072  08fc               L367:
3073                     ; 360         Lcd_Print_String("--");
3075  08fc ae0121        	ldw	x,#L177
3076  08ff cd0339        	call	_Lcd_Print_String
3078  0902               L357:
3079                     ; 362 }
3082  0902 81            	ret
3115                     ; 364 void Read_From_Tuner(void) {
3116                     	switch	.text
3117  0903               _Read_From_Tuner:
3121                     ; 365     SW_I2C_start();
3123  0903 cd0000        	call	_SW_I2C_start
3125                     ; 366 		SW_I2C_write(TDA6508A_I2C_READ);
3127  0906 a6c1          	ld	a,#193
3128  0908 cd0000        	call	_SW_I2C_write
3130                     ; 367 		if (SW_I2C_wait_ACK()) {
3132  090b cd0000        	call	_SW_I2C_wait_ACK
3134  090e 4d            	tnz	a
3135  090f 2704          	jreq	L3001
3136                     ; 368 				SW_I2C_stop(); 
3138  0911 cd0000        	call	_SW_I2C_stop
3140                     ; 369         return;
3143  0914 81            	ret
3144  0915               L3001:
3145                     ; 371     status_byte = SW_I2C_read(I2C_NACK);
3147  0915 4f            	clr	a
3148  0916 cd0000        	call	_SW_I2C_read
3150  0919 b708          	ld	_status_byte,a
3151                     ; 372     SW_I2C_stop();
3153  091b cd0000        	call	_SW_I2C_stop
3155                     ; 373 		Lcd_Clear();
3157  091e cd028f        	call	_Lcd_Clear
3159                     ; 374     Lcd_Set_Cursor(1, 3);
3161  0921 ae0103        	ldw	x,#259
3162  0924 cd0299        	call	_Lcd_Set_Cursor
3164                     ; 375     Lcd_Print_String("STAV TUNERU:");
3166  0927 ae0114        	ldw	x,#L5001
3167  092a cd0339        	call	_Lcd_Print_String
3169                     ; 376 		Lcd_Set_Cursor(2, 1);
3171  092d ae0201        	ldw	x,#513
3172  0930 cd0299        	call	_Lcd_Set_Cursor
3174                     ; 378     Lcd_Print_String("POR:");
3176  0933 ae010f        	ldw	x,#L7001
3177  0936 cd0339        	call	_Lcd_Print_String
3179                     ; 379     if ((status_byte >> 7) & 1){
3181  0939 b608          	ld	a,_status_byte
3182  093b 49            	rlc	a
3183  093c 4f            	clr	a
3184  093d 49            	rlc	a
3185  093e 5f            	clrw	x
3186  093f 97            	ld	xl,a
3187  0940 a30000        	cpw	x,#0
3188  0943 2708          	jreq	L1101
3189                     ; 380         Lcd_Print_String("A");  
3191  0945 ae010d        	ldw	x,#L3101
3192  0948 cd0339        	call	_Lcd_Print_String
3195  094b 2006          	jra	L5101
3196  094d               L1101:
3197                     ; 382         Lcd_Print_String("N");
3199  094d ae010b        	ldw	x,#L7101
3200  0950 cd0339        	call	_Lcd_Print_String
3202  0953               L5101:
3203                     ; 384     Lcd_Set_Cursor(2, 7);
3205  0953 ae0207        	ldw	x,#519
3206  0956 cd0299        	call	_Lcd_Set_Cursor
3208                     ; 386     Lcd_Print_String("FL:");
3210  0959 ae0107        	ldw	x,#L1201
3211  095c cd0339        	call	_Lcd_Print_String
3213                     ; 387     if ((status_byte >> 6) & 1){
3215  095f b608          	ld	a,_status_byte
3216  0961 4e            	swap	a
3217  0962 44            	srl	a
3218  0963 44            	srl	a
3219  0964 a403          	and	a,#3
3220  0966 5f            	clrw	x
3221  0967 a401          	and	a,#1
3222  0969 5f            	clrw	x
3223  096a 5f            	clrw	x
3224  096b 97            	ld	xl,a
3225  096c a30000        	cpw	x,#0
3226  096f 2708          	jreq	L3201
3227                     ; 388         Lcd_Print_String("Z");
3229  0971 ae0105        	ldw	x,#L5201
3230  0974 cd0339        	call	_Lcd_Print_String
3233  0977 2006          	jra	L7201
3234  0979               L3201:
3235                     ; 390         Lcd_Print_String("O");
3237  0979 ae0103        	ldw	x,#L1301
3238  097c cd0339        	call	_Lcd_Print_String
3240  097f               L7201:
3241                     ; 392 		Lcd_Set_Cursor(2, 12);
3243  097f ae020c        	ldw	x,#524
3244  0982 cd0299        	call	_Lcd_Set_Cursor
3246                     ; 394     Lcd_Print_String("ADC: ");
3248  0985 ae00fd        	ldw	x,#L3301
3249  0988 cd0339        	call	_Lcd_Print_String
3251                     ; 395 		adc = status_byte & 7;
3253  098b b608          	ld	a,_status_byte
3254  098d a407          	and	a,#7
3255  098f 5f            	clrw	x
3256  0990 97            	ld	xl,a
3257  0991 bf06          	ldw	_adc,x
3258                     ; 396 		Lcd_Set_Cursor(2, 16);
3260  0993 ae0210        	ldw	x,#528
3261  0996 cd0299        	call	_Lcd_Set_Cursor
3263                     ; 397     if (adc == 0){
3265  0999 be06          	ldw	x,_adc
3266  099b 2608          	jrne	L5301
3267                     ; 398 			Lcd_Print_String("0");
3269  099d ae00fb        	ldw	x,#L7301
3270  09a0 cd0339        	call	_Lcd_Print_String
3273  09a3 203a          	jra	L1401
3274  09a5               L5301:
3275                     ; 400 		else if (adc == 1){
3277  09a5 be06          	ldw	x,_adc
3278  09a7 a30001        	cpw	x,#1
3279  09aa 2608          	jrne	L3401
3280                     ; 401 			Lcd_Print_String("1");
3282  09ac ae00f9        	ldw	x,#L5401
3283  09af cd0339        	call	_Lcd_Print_String
3286  09b2 202b          	jra	L1401
3287  09b4               L3401:
3288                     ; 403 		else if (adc == 2){
3290  09b4 be06          	ldw	x,_adc
3291  09b6 a30002        	cpw	x,#2
3292  09b9 2608          	jrne	L1501
3293                     ; 404 			Lcd_Print_String("2");
3295  09bb ae00f7        	ldw	x,#L3501
3296  09be cd0339        	call	_Lcd_Print_String
3299  09c1 201c          	jra	L1401
3300  09c3               L1501:
3301                     ; 406 		else if (adc == 3){
3303  09c3 be06          	ldw	x,_adc
3304  09c5 a30003        	cpw	x,#3
3305  09c8 2608          	jrne	L7501
3306                     ; 407 			Lcd_Print_String("3");
3308  09ca ae00f5        	ldw	x,#L1601
3309  09cd cd0339        	call	_Lcd_Print_String
3312  09d0 200d          	jra	L1401
3313  09d2               L7501:
3314                     ; 409 		else if (adc == 4){
3316  09d2 be06          	ldw	x,_adc
3317  09d4 a30004        	cpw	x,#4
3318  09d7 2606          	jrne	L1401
3319                     ; 410 			Lcd_Print_String("4");
3321  09d9 ae00f3        	ldw	x,#L7601
3322  09dc cd0339        	call	_Lcd_Print_String
3324  09df               L1401:
3325                     ; 412 }
3328  09df 81            	ret
3355                     ; 414 void Load_Animation(void) {
3356                     	switch	.text
3357  09e0               _Load_Animation:
3361                     ; 415     for (cnt = 0; cnt < 17; cnt++) {
3363  09e0 5f            	clrw	x
3364  09e1 bf2a          	ldw	_cnt,x
3365  09e3               L1011:
3366                     ; 416         Lcd_Set_Cursor(2, cnt);
3368  09e3 b62b          	ld	a,_cnt+1
3369  09e5 ae0200        	ldw	x,#512
3370  09e8 97            	ld	xl,a
3371  09e9 cd0299        	call	_Lcd_Set_Cursor
3373                     ; 417         Lcd_Print_Char(0xFF);
3375  09ec a6ff          	ld	a,#255
3376  09ee cd02e4        	call	_Lcd_Print_Char
3378                     ; 418         delay_ms(100);
3380  09f1 ae0064        	ldw	x,#100
3381  09f4 cd0000        	call	_delay_ms
3383                     ; 415     for (cnt = 0; cnt < 17; cnt++) {
3385  09f7 be2a          	ldw	x,_cnt
3386  09f9 1c0001        	addw	x,#1
3387  09fc bf2a          	ldw	_cnt,x
3390  09fe 9c            	rvf
3391  09ff be2a          	ldw	x,_cnt
3392  0a01 a30011        	cpw	x,#17
3393  0a04 2fdd          	jrslt	L1011
3394                     ; 420     delay_ms(100);
3396  0a06 ae0064        	ldw	x,#100
3397  0a09 cd0000        	call	_delay_ms
3399                     ; 421 }
3402  0a0c 81            	ret
3426                     ; 424 void GPIO_Init_Encoder(void) {
3427                     	switch	.text
3428  0a0d               _GPIO_Init_Encoder:
3432                     ; 425     GPIO_Init(CLK_PIN, GPIO_MODE_IN_PU_NO_IT);
3434  0a0d 4b40          	push	#64
3435  0a0f 4b08          	push	#8
3436  0a11 ae500f        	ldw	x,#20495
3437  0a14 cd0000        	call	_GPIO_Init
3439  0a17 85            	popw	x
3440                     ; 426     GPIO_Init(DT_PIN, GPIO_MODE_IN_PU_NO_IT);
3442  0a18 4b40          	push	#64
3443  0a1a 4b10          	push	#16
3444  0a1c ae500a        	ldw	x,#20490
3445  0a1f cd0000        	call	_GPIO_Init
3447  0a22 85            	popw	x
3448                     ; 427 }
3451  0a23 81            	ret
3475                     ; 429 void GPIO_Init_Keypad(void) {
3476                     	switch	.text
3477  0a24               _GPIO_Init_Keypad:
3481                     ; 430 		GPIO_Init(KR_PO, KR1_P | KR2_P | KR3_P | KR4_P, GPIO_MODE_IN_PU_NO_IT);
3483  0a24 4b40          	push	#64
3484  0a26 4be8          	push	#232
3485  0a28 ae500a        	ldw	x,#20490
3486  0a2b cd0000        	call	_GPIO_Init
3488  0a2e 85            	popw	x
3489                     ; 431     GPIO_Init(KS_PO, KS1_P | KS2_P | KS3_P, GPIO_MODE_OUT_OD_HIZ_FAST);
3491  0a2f 4bb0          	push	#176
3492  0a31 4b0e          	push	#14
3493  0a33 ae5014        	ldw	x,#20500
3494  0a36 cd0000        	call	_GPIO_Init
3496  0a39 85            	popw	x
3497                     ; 432 }
3500  0a3a 81            	ret
3524                     ; 434 void GPIO_Init_Buttons(void){
3525                     	switch	.text
3526  0a3b               _GPIO_Init_Buttons:
3530                     ; 435 	GPIO_Init(BTN1_PIN, GPIO_MODE_IN_PU_NO_IT);
3532  0a3b 4b40          	push	#64
3533  0a3d 4b01          	push	#1
3534  0a3f ae5005        	ldw	x,#20485
3535  0a42 cd0000        	call	_GPIO_Init
3537  0a45 85            	popw	x
3538                     ; 436 	GPIO_Init(BTN2_PIN, GPIO_MODE_IN_PU_NO_IT);
3540  0a46 4b40          	push	#64
3541  0a48 4b02          	push	#2
3542  0a4a ae5005        	ldw	x,#20485
3543  0a4d cd0000        	call	_GPIO_Init
3545  0a50 85            	popw	x
3546                     ; 437 	GPIO_Init(BTN3_PIN, GPIO_MODE_IN_PU_NO_IT);
3548  0a51 4b40          	push	#64
3549  0a53 4b04          	push	#4
3550  0a55 ae5005        	ldw	x,#20485
3551  0a58 cd0000        	call	_GPIO_Init
3553  0a5b 85            	popw	x
3554                     ; 438 	GPIO_Init(BTN4_PIN, GPIO_MODE_IN_PU_NO_IT);
3556  0a5c 4b40          	push	#64
3557  0a5e 4b08          	push	#8
3558  0a60 ae5005        	ldw	x,#20485
3559  0a63 cd0000        	call	_GPIO_Init
3561  0a66 85            	popw	x
3562                     ; 439 }
3565  0a67 81            	ret
3596                     ; 443 void Control_Byte_Settings(void) {
3597                     	switch	.text
3598  0a68               _Control_Byte_Settings:
3602                     ; 444 		if (sb>1){
3604  0a68 9c            	rvf
3605  0a69 be0c          	ldw	x,_sb
3606  0a6b a30002        	cpw	x,#2
3607  0a6e 2f03          	jrslt	L7411
3608                     ; 445 			sb=0;
3610  0a70 5f            	clrw	x
3611  0a71 bf0c          	ldw	_sb,x
3612  0a73               L7411:
3613                     ; 447 		Lcd_Set_Cursor(1, 12);
3615  0a73 ae010c        	ldw	x,#268
3616  0a76 cd0299        	call	_Lcd_Set_Cursor
3618                     ; 448 		if (sb == 1) {
3620  0a79 be0c          	ldw	x,_sb
3621  0a7b a30001        	cpw	x,#1
3622  0a7e 2608          	jrne	L1511
3623                     ; 449 				Lcd_Print_String("A");  
3625  0a80 ae010d        	ldw	x,#L3101
3626  0a83 cd0339        	call	_Lcd_Print_String
3629  0a86 2006          	jra	L3511
3630  0a88               L1511:
3631                     ; 451 				Lcd_Print_String("N");
3633  0a88 ae010b        	ldw	x,#L7101
3634  0a8b cd0339        	call	_Lcd_Print_String
3636  0a8e               L3511:
3637                     ; 453 		cb = 0b11000000 | ((sb & 1) << 0);
3639  0a8e b60d          	ld	a,_sb+1
3640  0a90 a401          	and	a,#1
3641  0a92 aac0          	or	a,#192
3642  0a94 b719          	ld	_cb,a
3643                     ; 454     buf2[0] = cb;       
3645  0a96 451913        	mov	_buf2,_cb
3646                     ; 455     buf2[1] = bb;  
3648  0a99 451a14        	mov	_buf2+1,_bb
3649                     ; 456     Send_I2C_Buffer(TDA6508A_I2C_WRITE, buf2, 2);
3651  0a9c 4b02          	push	#2
3652  0a9e ae0013        	ldw	x,#_buf2
3653  0aa1 89            	pushw	x
3654  0aa2 a6c0          	ld	a,#192
3655  0aa4 cd0f25        	call	_Send_I2C_Buffer
3657  0aa7 5b03          	addw	sp,#3
3658                     ; 457 }
3661  0aa9 81            	ret
3664                     	bsct
3665  0013               L5511_lastState:
3666  0013 00            	dc.b	0
3712                     ; 459 void Encoder_Read(void) {
3713                     	switch	.text
3714  0aaa               _Encoder_Read:
3716  0aaa 88            	push	a
3717       00000001      OFST:	set	1
3720                     ; 461     uint8_t currentState = 0;
3722  0aab 0f01          	clr	(OFST+0,sp)
3724                     ; 21 	_asm("nop\n $N:\n decw X\n jrne $L\n nop\n ", __ticks);
3728  0aad ae0321        	ldw	x,#801
3730  0ab0 9d            nop
3731  0ab1                L011:
3732  0ab1 5a             decw X
3733  0ab2 26fd           jrne L011
3734  0ab4 9d             nop
3735                      
3737  0ab5               L1611:
3738                     ; 463     if (GPIO_ReadInputPin(CLK_PIN)) currentState |= 0x01;
3740  0ab5 4b08          	push	#8
3741  0ab7 ae500f        	ldw	x,#20495
3742  0aba cd0000        	call	_GPIO_ReadInputPin
3744  0abd 5b01          	addw	sp,#1
3745  0abf 4d            	tnz	a
3746  0ac0 2706          	jreq	L5021
3749  0ac2 7b01          	ld	a,(OFST+0,sp)
3750  0ac4 aa01          	or	a,#1
3751  0ac6 6b01          	ld	(OFST+0,sp),a
3753  0ac8               L5021:
3754                     ; 464     if (GPIO_ReadInputPin(DT_PIN)) currentState |= 0x02;
3756  0ac8 4b10          	push	#16
3757  0aca ae500a        	ldw	x,#20490
3758  0acd cd0000        	call	_GPIO_ReadInputPin
3760  0ad0 5b01          	addw	sp,#1
3761  0ad2 4d            	tnz	a
3762  0ad3 2706          	jreq	L7021
3765  0ad5 7b01          	ld	a,(OFST+0,sp)
3766  0ad7 aa02          	or	a,#2
3767  0ad9 6b01          	ld	(OFST+0,sp),a
3769  0adb               L7021:
3770                     ; 465     if ((lastState == 0x00 && currentState == 0x01) ||
3770                     ; 466         (lastState == 0x01 && currentState == 0x03) ||
3770                     ; 467         (lastState == 0x03 && currentState == 0x02) ||
3770                     ; 468         (lastState == 0x02 && currentState == 0x00)) {
3772  0adb 3d13          	tnz	L5511_lastState
3773  0add 2606          	jrne	L5121
3775  0adf 7b01          	ld	a,(OFST+0,sp)
3776  0ae1 a101          	cp	a,#1
3777  0ae3 2722          	jreq	L3121
3778  0ae5               L5121:
3780  0ae5 b613          	ld	a,L5511_lastState
3781  0ae7 a101          	cp	a,#1
3782  0ae9 2606          	jrne	L1221
3784  0aeb 7b01          	ld	a,(OFST+0,sp)
3785  0aed a103          	cp	a,#3
3786  0aef 2716          	jreq	L3121
3787  0af1               L1221:
3789  0af1 b613          	ld	a,L5511_lastState
3790  0af3 a103          	cp	a,#3
3791  0af5 2606          	jrne	L5221
3793  0af7 7b01          	ld	a,(OFST+0,sp)
3794  0af9 a102          	cp	a,#2
3795  0afb 270a          	jreq	L3121
3796  0afd               L5221:
3798  0afd b613          	ld	a,L5511_lastState
3799  0aff a102          	cp	a,#2
3800  0b01 2608          	jrne	L1121
3802  0b03 0d01          	tnz	(OFST+0,sp)
3803  0b05 2604          	jrne	L1121
3804  0b07               L3121:
3805                     ; 469         frec2 += 1; 
3807  0b07 3c27          	inc	_frec2
3809  0b09 202e          	jra	L7221
3810  0b0b               L1121:
3811                     ; 470     } else if ((lastState == 0x00 && currentState == 0x02) ||
3811                     ; 471                (lastState == 0x02 && currentState == 0x03) ||
3811                     ; 472                (lastState == 0x03 && currentState == 0x01) ||
3811                     ; 473                (lastState == 0x01 && currentState == 0x00)) {
3813  0b0b 3d13          	tnz	L5511_lastState
3814  0b0d 2606          	jrne	L5321
3816  0b0f 7b01          	ld	a,(OFST+0,sp)
3817  0b11 a102          	cp	a,#2
3818  0b13 2722          	jreq	L3321
3819  0b15               L5321:
3821  0b15 b613          	ld	a,L5511_lastState
3822  0b17 a102          	cp	a,#2
3823  0b19 2606          	jrne	L1421
3825  0b1b 7b01          	ld	a,(OFST+0,sp)
3826  0b1d a103          	cp	a,#3
3827  0b1f 2716          	jreq	L3321
3828  0b21               L1421:
3830  0b21 b613          	ld	a,L5511_lastState
3831  0b23 a103          	cp	a,#3
3832  0b25 2606          	jrne	L5421
3834  0b27 7b01          	ld	a,(OFST+0,sp)
3835  0b29 a101          	cp	a,#1
3836  0b2b 270a          	jreq	L3321
3837  0b2d               L5421:
3839  0b2d b613          	ld	a,L5511_lastState
3840  0b2f a101          	cp	a,#1
3841  0b31 2606          	jrne	L7221
3843  0b33 0d01          	tnz	(OFST+0,sp)
3844  0b35 2602          	jrne	L7221
3845  0b37               L3321:
3846                     ; 474         frec2 -= 1;
3848  0b37 3a27          	dec	_frec2
3849  0b39               L7221:
3850                     ; 476     lastState = currentState;
3852  0b39 7b01          	ld	a,(OFST+0,sp)
3853  0b3b b713          	ld	L5511_lastState,a
3854                     ; 477 }
3857  0b3d 84            	pop	a
3858  0b3e 81            	ret
3884                     ; 479 void LCD_Dec_Fix (void) {
3885                     	switch	.text
3886  0b3f               _LCD_Dec_Fix:
3890                     ; 480 		if (frec2 == 0) {
3892  0b3f 3d27          	tnz	_frec2
3893  0b41 260f          	jrne	L7521
3894                     ; 481 		Lcd_Set_Cursor(2, 9);
3896  0b43 ae0209        	ldw	x,#521
3897  0b46 cd0299        	call	_Lcd_Set_Cursor
3899                     ; 482 		Lcd_Print_Char('0');
3901  0b49 a630          	ld	a,#48
3902  0b4b cd02e4        	call	_Lcd_Print_Char
3905  0b4e acff0bff      	jpf	L1621
3906  0b52               L7521:
3907                     ; 484 		else if (frec2 == 1) {
3909  0b52 b627          	ld	a,_frec2
3910  0b54 a101          	cp	a,#1
3911  0b56 260f          	jrne	L3621
3912                     ; 485 		Lcd_Set_Cursor(2, 9);
3914  0b58 ae0209        	ldw	x,#521
3915  0b5b cd0299        	call	_Lcd_Set_Cursor
3917                     ; 486 		Lcd_Print_Char('1');
3919  0b5e a631          	ld	a,#49
3920  0b60 cd02e4        	call	_Lcd_Print_Char
3923  0b63 acff0bff      	jpf	L1621
3924  0b67               L3621:
3925                     ; 488 		else if (frec2 == 2) {
3927  0b67 b627          	ld	a,_frec2
3928  0b69 a102          	cp	a,#2
3929  0b6b 260f          	jrne	L7621
3930                     ; 489 		Lcd_Set_Cursor(2, 9);
3932  0b6d ae0209        	ldw	x,#521
3933  0b70 cd0299        	call	_Lcd_Set_Cursor
3935                     ; 490 		Lcd_Print_Char('2');
3937  0b73 a632          	ld	a,#50
3938  0b75 cd02e4        	call	_Lcd_Print_Char
3941  0b78 acff0bff      	jpf	L1621
3942  0b7c               L7621:
3943                     ; 492 		else if (frec2 == 3) {
3945  0b7c b627          	ld	a,_frec2
3946  0b7e a103          	cp	a,#3
3947  0b80 260d          	jrne	L3721
3948                     ; 493 		Lcd_Set_Cursor(2, 9);
3950  0b82 ae0209        	ldw	x,#521
3951  0b85 cd0299        	call	_Lcd_Set_Cursor
3953                     ; 494 		Lcd_Print_Char('3');
3955  0b88 a633          	ld	a,#51
3956  0b8a cd02e4        	call	_Lcd_Print_Char
3959  0b8d 2070          	jra	L1621
3960  0b8f               L3721:
3961                     ; 496 		else if (frec2 == 4) {
3963  0b8f b627          	ld	a,_frec2
3964  0b91 a104          	cp	a,#4
3965  0b93 260d          	jrne	L7721
3966                     ; 497 		Lcd_Set_Cursor(2, 9);
3968  0b95 ae0209        	ldw	x,#521
3969  0b98 cd0299        	call	_Lcd_Set_Cursor
3971                     ; 498 		Lcd_Print_Char('4');
3973  0b9b a634          	ld	a,#52
3974  0b9d cd02e4        	call	_Lcd_Print_Char
3977  0ba0 205d          	jra	L1621
3978  0ba2               L7721:
3979                     ; 500 		else if (frec2 == 5) {
3981  0ba2 b627          	ld	a,_frec2
3982  0ba4 a105          	cp	a,#5
3983  0ba6 260d          	jrne	L3031
3984                     ; 501 		Lcd_Set_Cursor(2, 9);
3986  0ba8 ae0209        	ldw	x,#521
3987  0bab cd0299        	call	_Lcd_Set_Cursor
3989                     ; 502 		Lcd_Print_Char('5');
3991  0bae a635          	ld	a,#53
3992  0bb0 cd02e4        	call	_Lcd_Print_Char
3995  0bb3 204a          	jra	L1621
3996  0bb5               L3031:
3997                     ; 504 		else if (frec2 == 6) {
3999  0bb5 b627          	ld	a,_frec2
4000  0bb7 a106          	cp	a,#6
4001  0bb9 260d          	jrne	L7031
4002                     ; 505 		Lcd_Set_Cursor(2, 9);
4004  0bbb ae0209        	ldw	x,#521
4005  0bbe cd0299        	call	_Lcd_Set_Cursor
4007                     ; 506 		Lcd_Print_Char('6');
4009  0bc1 a636          	ld	a,#54
4010  0bc3 cd02e4        	call	_Lcd_Print_Char
4013  0bc6 2037          	jra	L1621
4014  0bc8               L7031:
4015                     ; 508 		else if (frec2 == 7) {
4017  0bc8 b627          	ld	a,_frec2
4018  0bca a107          	cp	a,#7
4019  0bcc 260d          	jrne	L3131
4020                     ; 509 		Lcd_Set_Cursor(2, 9);
4022  0bce ae0209        	ldw	x,#521
4023  0bd1 cd0299        	call	_Lcd_Set_Cursor
4025                     ; 510 		Lcd_Print_Char('7');
4027  0bd4 a637          	ld	a,#55
4028  0bd6 cd02e4        	call	_Lcd_Print_Char
4031  0bd9 2024          	jra	L1621
4032  0bdb               L3131:
4033                     ; 512 		else if (frec2 == 8) {
4035  0bdb b627          	ld	a,_frec2
4036  0bdd a108          	cp	a,#8
4037  0bdf 260d          	jrne	L7131
4038                     ; 513 		Lcd_Set_Cursor(2, 9);
4040  0be1 ae0209        	ldw	x,#521
4041  0be4 cd0299        	call	_Lcd_Set_Cursor
4043                     ; 514 		Lcd_Print_Char('8');
4045  0be7 a638          	ld	a,#56
4046  0be9 cd02e4        	call	_Lcd_Print_Char
4049  0bec 2011          	jra	L1621
4050  0bee               L7131:
4051                     ; 516 		else if (frec2 == 9) {
4053  0bee b627          	ld	a,_frec2
4054  0bf0 a109          	cp	a,#9
4055  0bf2 260b          	jrne	L1621
4056                     ; 517 		Lcd_Set_Cursor(2, 9);
4058  0bf4 ae0209        	ldw	x,#521
4059  0bf7 cd0299        	call	_Lcd_Set_Cursor
4061                     ; 518 		Lcd_Print_Char('9');
4063  0bfa a639          	ld	a,#57
4064  0bfc cd02e4        	call	_Lcd_Print_Char
4066  0bff               L1621:
4067                     ; 520 }
4070  0bff 81            	ret
4096                     ; 522 void Additional_Info(void){
4097                     	switch	.text
4098  0c00               _Additional_Info:
4102                     ; 523 				if (frec >=87.6 && frec<= 108.0) {
4104  0c00 9c            	rvf
4105  0c01 ae0021        	ldw	x,#_frec
4106  0c04 cd0000        	call	c_ltor
4108  0c07 ae00ef        	ldw	x,#L3431
4109  0c0a cd0000        	call	c_fcmp
4111  0c0d 2f2b          	jrslt	L5331
4113  0c0f 9c            	rvf
4114  0c10 ae0021        	ldw	x,#_frec
4115  0c13 cd0000        	call	c_ltor
4117  0c16 ae00eb        	ldw	x,#L3531
4118  0c19 cd0000        	call	c_fcmp
4120  0c1c 2c1c          	jrsgt	L5331
4121                     ; 524 								Lcd_Set_Cursor(2,3);
4123  0c1e ae0203        	ldw	x,#515
4124  0c21 cd0299        	call	_Lcd_Set_Cursor
4126                     ; 525 								Lcd_Print_String(" ");
4128  0c24 ae01fb        	ldw	x,#L112
4129  0c27 cd0339        	call	_Lcd_Print_String
4131                     ; 526                 Lcd_Set_Cursor(2,1);
4133  0c2a ae0201        	ldw	x,#513
4134  0c2d cd0299        	call	_Lcd_Set_Cursor
4136                     ; 527                 Lcd_Print_String("FM");
4138  0c30 ae00e8        	ldw	x,#L7531
4139  0c33 cd0339        	call	_Lcd_Print_String
4142  0c36 ac240f24      	jpf	L1631
4143  0c3a               L5331:
4144                     ; 529 				else if (frec >108.0 && frec <=136.0) {   
4146  0c3a 9c            	rvf
4147  0c3b ae0021        	ldw	x,#_frec
4148  0c3e cd0000        	call	c_ltor
4150  0c41 ae00eb        	ldw	x,#L3531
4151  0c44 cd0000        	call	c_fcmp
4153  0c47 2d1f          	jrsle	L3631
4155  0c49 9c            	rvf
4156  0c4a ae0021        	ldw	x,#_frec
4157  0c4d cd0000        	call	c_ltor
4159  0c50 ae00e4        	ldw	x,#L1731
4160  0c53 cd0000        	call	c_fcmp
4162  0c56 2c10          	jrsgt	L3631
4163                     ; 530                 Lcd_Set_Cursor(2,1);
4165  0c58 ae0201        	ldw	x,#513
4166  0c5b cd0299        	call	_Lcd_Set_Cursor
4168                     ; 531                 Lcd_Print_String("AIR");  
4170  0c5e ae00e0        	ldw	x,#L5731
4171  0c61 cd0339        	call	_Lcd_Print_String
4174  0c64 ac240f24      	jpf	L1631
4175  0c68               L3631:
4176                     ; 533 				else if (frec >=137.0 && frec <=138.0) {   
4178  0c68 9c            	rvf
4179  0c69 ae0021        	ldw	x,#_frec
4180  0c6c cd0000        	call	c_ltor
4182  0c6f ae00dc        	ldw	x,#L7041
4183  0c72 cd0000        	call	c_fcmp
4185  0c75 2f1f          	jrslt	L1041
4187  0c77 9c            	rvf
4188  0c78 ae0021        	ldw	x,#_frec
4189  0c7b cd0000        	call	c_ltor
4191  0c7e ae00d8        	ldw	x,#L7141
4192  0c81 cd0000        	call	c_fcmp
4194  0c84 2c10          	jrsgt	L1041
4195                     ; 534                 Lcd_Set_Cursor(2,1);
4197  0c86 ae0201        	ldw	x,#513
4198  0c89 cd0299        	call	_Lcd_Set_Cursor
4200                     ; 535                 Lcd_Print_String("SAT");  
4202  0c8c ae00d4        	ldw	x,#L3241
4203  0c8f cd0339        	call	_Lcd_Print_String
4206  0c92 ac240f24      	jpf	L1631
4207  0c96               L1041:
4208                     ; 537 				else if (frec >=174.0 && frec <=239.0){
4210  0c96 9c            	rvf
4211  0c97 ae0021        	ldw	x,#_frec
4212  0c9a cd0000        	call	c_ltor
4214  0c9d ae00d0        	ldw	x,#L5341
4215  0ca0 cd0000        	call	c_fcmp
4217  0ca3 2f1f          	jrslt	L7241
4219  0ca5 9c            	rvf
4220  0ca6 ae0021        	ldw	x,#_frec
4221  0ca9 cd0000        	call	c_ltor
4223  0cac ae00cc        	ldw	x,#L5441
4224  0caf cd0000        	call	c_fcmp
4226  0cb2 2c10          	jrsgt	L7241
4227                     ; 538 								Lcd_Set_Cursor(2,1);
4229  0cb4 ae0201        	ldw	x,#513
4230  0cb7 cd0299        	call	_Lcd_Set_Cursor
4232                     ; 539                 Lcd_Print_String("DAB"); 
4234  0cba ae00c8        	ldw	x,#L1541
4235  0cbd cd0339        	call	_Lcd_Print_String
4238  0cc0 ac240f24      	jpf	L1631
4239  0cc4               L7241:
4240                     ; 541 				else if (frec>239.0 && frec<380.0){
4242  0cc4 9c            	rvf
4243  0cc5 ae0021        	ldw	x,#_frec
4244  0cc8 cd0000        	call	c_ltor
4246  0ccb ae00cc        	ldw	x,#L5441
4247  0cce cd0000        	call	c_fcmp
4249  0cd1 2d1f          	jrsle	L5541
4251  0cd3 9c            	rvf
4252  0cd4 ae0021        	ldw	x,#_frec
4253  0cd7 cd0000        	call	c_ltor
4255  0cda ae00c4        	ldw	x,#L3641
4256  0cdd cd0000        	call	c_fcmp
4258  0ce0 2e10          	jrsge	L5541
4259                     ; 542 								Lcd_Set_Cursor(2,1);
4261  0ce2 ae0201        	ldw	x,#513
4262  0ce5 cd0299        	call	_Lcd_Set_Cursor
4264                     ; 543 								Lcd_Print_String("MIL");
4266  0ce8 ae00c0        	ldw	x,#L7641
4267  0ceb cd0339        	call	_Lcd_Print_String
4270  0cee ac240f24      	jpf	L1631
4271  0cf2               L5541:
4272                     ; 545 				else if (frec >=433.0 && frec <434.9 || frec >=855.0 && frec <=868.0) {  
4274  0cf2 9c            	rvf
4275  0cf3 ae0021        	ldw	x,#_frec
4276  0cf6 cd0000        	call	c_ltor
4278  0cf9 ae00bc        	ldw	x,#L5051
4279  0cfc cd0000        	call	c_fcmp
4281  0cff 2f0f          	jrslt	L7741
4283  0d01 9c            	rvf
4284  0d02 ae0021        	ldw	x,#_frec
4285  0d05 cd0000        	call	c_ltor
4287  0d08 ae00b8        	ldw	x,#L5151
4288  0d0b cd0000        	call	c_fcmp
4290  0d0e 2f1e          	jrslt	L5741
4291  0d10               L7741:
4293  0d10 9c            	rvf
4294  0d11 ae0021        	ldw	x,#_frec
4295  0d14 cd0000        	call	c_ltor
4297  0d17 ae00b4        	ldw	x,#L5251
4298  0d1a cd0000        	call	c_fcmp
4300  0d1d 2f1f          	jrslt	L3741
4302  0d1f 9c            	rvf
4303  0d20 ae0021        	ldw	x,#_frec
4304  0d23 cd0000        	call	c_ltor
4306  0d26 ae00b0        	ldw	x,#L5351
4307  0d29 cd0000        	call	c_fcmp
4309  0d2c 2c10          	jrsgt	L3741
4310  0d2e               L5741:
4311                     ; 546                 Lcd_Set_Cursor(2,1);
4313  0d2e ae0201        	ldw	x,#513
4314  0d31 cd0299        	call	_Lcd_Set_Cursor
4316                     ; 547                 Lcd_Print_String("ISM");  
4318  0d34 ae00ac        	ldw	x,#L1451
4319  0d37 cd0339        	call	_Lcd_Print_String
4322  0d3a ac240f24      	jpf	L1631
4323  0d3e               L3741:
4324                     ; 549 				else if (frec>=144.0 && frec<=148.0){
4326  0d3e 9c            	rvf
4327  0d3f ae0021        	ldw	x,#_frec
4328  0d42 cd0000        	call	c_ltor
4330  0d45 ae00a8        	ldw	x,#L3551
4331  0d48 cd0000        	call	c_fcmp
4333  0d4b 2f2b          	jrslt	L5451
4335  0d4d 9c            	rvf
4336  0d4e ae0021        	ldw	x,#_frec
4337  0d51 cd0000        	call	c_ltor
4339  0d54 ae00a4        	ldw	x,#L3651
4340  0d57 cd0000        	call	c_fcmp
4342  0d5a 2c1c          	jrsgt	L5451
4343                     ; 550 								Lcd_Set_Cursor(2,3);
4345  0d5c ae0203        	ldw	x,#515
4346  0d5f cd0299        	call	_Lcd_Set_Cursor
4348                     ; 551 								Lcd_Print_String(" ");
4350  0d62 ae01fb        	ldw	x,#L112
4351  0d65 cd0339        	call	_Lcd_Print_String
4353                     ; 552 								Lcd_Set_Cursor(2,1);
4355  0d68 ae0201        	ldw	x,#513
4356  0d6b cd0299        	call	_Lcd_Set_Cursor
4358                     ; 553 								Lcd_Print_String("2M");
4360  0d6e ae00a1        	ldw	x,#L7651
4361  0d71 cd0339        	call	_Lcd_Print_String
4364  0d74 ac240f24      	jpf	L1631
4365  0d78               L5451:
4366                     ; 555 				else if (frec>=160.0 && frec<=174.0){
4368  0d78 9c            	rvf
4369  0d79 ae0021        	ldw	x,#_frec
4370  0d7c cd0000        	call	c_ltor
4372  0d7f ae009d        	ldw	x,#L1061
4373  0d82 cd0000        	call	c_fcmp
4375  0d85 2f1f          	jrslt	L3751
4377  0d87 9c            	rvf
4378  0d88 ae0021        	ldw	x,#_frec
4379  0d8b cd0000        	call	c_ltor
4381  0d8e ae00d0        	ldw	x,#L5341
4382  0d91 cd0000        	call	c_fcmp
4384  0d94 2c10          	jrsgt	L3751
4385                     ; 556 								Lcd_Set_Cursor(2,1);
4387  0d96 ae0201        	ldw	x,#513
4388  0d99 cd0299        	call	_Lcd_Set_Cursor
4390                     ; 557 								Lcd_Print_String("IZS");
4392  0d9c ae0099        	ldw	x,#L5061
4393  0d9f cd0339        	call	_Lcd_Print_String
4396  0da2 ac240f24      	jpf	L1631
4397  0da6               L3751:
4398                     ; 559 				else if (frec>=430.0 && frec<=440.0){
4400  0da6 9c            	rvf
4401  0da7 ae0021        	ldw	x,#_frec
4402  0daa cd0000        	call	c_ltor
4404  0dad ae0095        	ldw	x,#L7161
4405  0db0 cd0000        	call	c_fcmp
4407  0db3 2f1f          	jrslt	L1161
4409  0db5 9c            	rvf
4410  0db6 ae0021        	ldw	x,#_frec
4411  0db9 cd0000        	call	c_ltor
4413  0dbc ae0091        	ldw	x,#L7261
4414  0dbf cd0000        	call	c_fcmp
4416  0dc2 2c10          	jrsgt	L1161
4417                     ; 560 								Lcd_Set_Cursor(2,1);
4419  0dc4 ae0201        	ldw	x,#513
4420  0dc7 cd0299        	call	_Lcd_Set_Cursor
4422                     ; 561 								Lcd_Print_String("3/4");
4424  0dca ae008d        	ldw	x,#L3361
4425  0dcd cd0339        	call	_Lcd_Print_String
4428  0dd0 ac240f24      	jpf	L1631
4429  0dd4               L1161:
4430                     ; 563 				else if (frec>=400.0 && frec<=406.0){
4432  0dd4 9c            	rvf
4433  0dd5 ae0021        	ldw	x,#_frec
4434  0dd8 cd0000        	call	c_ltor
4436  0ddb ae0089        	ldw	x,#L5461
4437  0dde cd0000        	call	c_fcmp
4439  0de1 2f1f          	jrslt	L7361
4441  0de3 9c            	rvf
4442  0de4 ae0021        	ldw	x,#_frec
4443  0de7 cd0000        	call	c_ltor
4445  0dea ae0085        	ldw	x,#L5561
4446  0ded cd0000        	call	c_fcmp
4448  0df0 2c10          	jrsgt	L7361
4449                     ; 564 								Lcd_Set_Cursor(2,1);
4451  0df2 ae0201        	ldw	x,#513
4452  0df5 cd0299        	call	_Lcd_Set_Cursor
4454                     ; 565 								Lcd_Print_String("WBL");
4456  0df8 ae0081        	ldw	x,#L1661
4457  0dfb cd0339        	call	_Lcd_Print_String
4460  0dfe ac240f24      	jpf	L1631
4461  0e02               L7361:
4462                     ; 567 				else if (frec>=410.0 && frec<430.0 || frec>=380.0 && frec<400.0){
4464  0e02 9c            	rvf
4465  0e03 ae0021        	ldw	x,#_frec
4466  0e06 cd0000        	call	c_ltor
4468  0e09 ae007d        	ldw	x,#L7761
4469  0e0c cd0000        	call	c_fcmp
4471  0e0f 2f0f          	jrslt	L1761
4473  0e11 9c            	rvf
4474  0e12 ae0021        	ldw	x,#_frec
4475  0e15 cd0000        	call	c_ltor
4477  0e18 ae0095        	ldw	x,#L7161
4478  0e1b cd0000        	call	c_fcmp
4480  0e1e 2f1e          	jrslt	L7661
4481  0e20               L1761:
4483  0e20 9c            	rvf
4484  0e21 ae0021        	ldw	x,#_frec
4485  0e24 cd0000        	call	c_ltor
4487  0e27 ae00c4        	ldw	x,#L3641
4488  0e2a cd0000        	call	c_fcmp
4490  0e2d 2f1f          	jrslt	L5661
4492  0e2f 9c            	rvf
4493  0e30 ae0021        	ldw	x,#_frec
4494  0e33 cd0000        	call	c_ltor
4496  0e36 ae0089        	ldw	x,#L5461
4497  0e39 cd0000        	call	c_fcmp
4499  0e3c 2e10          	jrsge	L5661
4500  0e3e               L7661:
4501                     ; 568 								Lcd_Set_Cursor(2,1);
4503  0e3e ae0201        	ldw	x,#513
4504  0e41 cd0299        	call	_Lcd_Set_Cursor
4506                     ; 569 								Lcd_Print_String("TET");
4508  0e44 ae0079        	ldw	x,#L3071
4509  0e47 cd0339        	call	_Lcd_Print_String
4512  0e4a ac240f24      	jpf	L1631
4513  0e4e               L5661:
4514                     ; 571 				else if (frec >=446.0 && frec <=446.2) {  
4516  0e4e 9c            	rvf
4517  0e4f ae0021        	ldw	x,#_frec
4518  0e52 cd0000        	call	c_ltor
4520  0e55 ae0075        	ldw	x,#L5171
4521  0e58 cd0000        	call	c_fcmp
4523  0e5b 2f1f          	jrslt	L7071
4525  0e5d 9c            	rvf
4526  0e5e ae0021        	ldw	x,#_frec
4527  0e61 cd0000        	call	c_ltor
4529  0e64 ae0071        	ldw	x,#L5271
4530  0e67 cd0000        	call	c_fcmp
4532  0e6a 2c10          	jrsgt	L7071
4533                     ; 572                 Lcd_Set_Cursor(2,1);
4535  0e6c ae0201        	ldw	x,#513
4536  0e6f cd0299        	call	_Lcd_Set_Cursor
4538                     ; 573                 Lcd_Print_String("PMR");  
4540  0e72 ae006d        	ldw	x,#L1371
4541  0e75 cd0339        	call	_Lcd_Print_String
4544  0e78 ac240f24      	jpf	L1631
4545  0e7c               L7071:
4546                     ; 575 				else if (frec>=50.0 && frec<=54.0){
4548  0e7c 9c            	rvf
4549  0e7d ae0021        	ldw	x,#_frec
4550  0e80 cd0000        	call	c_ltor
4552  0e83 ae0069        	ldw	x,#L3471
4553  0e86 cd0000        	call	c_fcmp
4555  0e89 2f29          	jrslt	L5371
4557  0e8b 9c            	rvf
4558  0e8c ae0021        	ldw	x,#_frec
4559  0e8f cd0000        	call	c_ltor
4561  0e92 ae0065        	ldw	x,#L3571
4562  0e95 cd0000        	call	c_fcmp
4564  0e98 2c1a          	jrsgt	L5371
4565                     ; 576 								Lcd_Set_Cursor(2,3);
4567  0e9a ae0203        	ldw	x,#515
4568  0e9d cd0299        	call	_Lcd_Set_Cursor
4570                     ; 577 								Lcd_Print_String(" ");
4572  0ea0 ae01fb        	ldw	x,#L112
4573  0ea3 cd0339        	call	_Lcd_Print_String
4575                     ; 578 								Lcd_Set_Cursor(2,1);
4577  0ea6 ae0201        	ldw	x,#513
4578  0ea9 cd0299        	call	_Lcd_Set_Cursor
4580                     ; 579 								Lcd_Print_String("6M");
4582  0eac ae0062        	ldw	x,#L7571
4583  0eaf cd0339        	call	_Lcd_Print_String
4586  0eb2 2070          	jra	L1631
4587  0eb4               L5371:
4588                     ; 581 				else if (frec>=67.6 && frec<=71.3){
4590  0eb4 9c            	rvf
4591  0eb5 ae0021        	ldw	x,#_frec
4592  0eb8 cd0000        	call	c_ltor
4594  0ebb ae005e        	ldw	x,#L1771
4595  0ebe cd0000        	call	c_fcmp
4597  0ec1 2f1d          	jrslt	L3671
4599  0ec3 9c            	rvf
4600  0ec4 ae0021        	ldw	x,#_frec
4601  0ec7 cd0000        	call	c_ltor
4603  0eca ae005a        	ldw	x,#L1002
4604  0ecd cd0000        	call	c_fcmp
4606  0ed0 2c0e          	jrsgt	L3671
4607                     ; 582 								Lcd_Set_Cursor(2,1);
4609  0ed2 ae0201        	ldw	x,#513
4610  0ed5 cd0299        	call	_Lcd_Set_Cursor
4612                     ; 583 								Lcd_Print_String("HLS");
4614  0ed8 ae0056        	ldw	x,#L5002
4615  0edb cd0339        	call	_Lcd_Print_String
4618  0ede 2044          	jra	L1631
4619  0ee0               L3671:
4620                     ; 585 				else if (frec>71.3 && frec<=72.8){
4622  0ee0 9c            	rvf
4623  0ee1 ae0021        	ldw	x,#_frec
4624  0ee4 cd0000        	call	c_ltor
4626  0ee7 ae005a        	ldw	x,#L1002
4627  0eea cd0000        	call	c_fcmp
4629  0eed 2d29          	jrsle	L1102
4631  0eef 9c            	rvf
4632  0ef0 ae0021        	ldw	x,#_frec
4633  0ef3 cd0000        	call	c_ltor
4635  0ef6 ae0052        	ldw	x,#L7102
4636  0ef9 cd0000        	call	c_fcmp
4638  0efc 2c1a          	jrsgt	L1102
4639                     ; 586 								Lcd_Set_Cursor(2,3);
4641  0efe ae0203        	ldw	x,#515
4642  0f01 cd0299        	call	_Lcd_Set_Cursor
4644                     ; 587 								Lcd_Print_String(" ");
4646  0f04 ae01fb        	ldw	x,#L112
4647  0f07 cd0339        	call	_Lcd_Print_String
4649                     ; 588 								Lcd_Set_Cursor(2,1);
4651  0f0a ae0201        	ldw	x,#513
4652  0f0d cd0299        	call	_Lcd_Set_Cursor
4654                     ; 589 								Lcd_Print_String("4M");
4656  0f10 ae004f        	ldw	x,#L3202
4657  0f13 cd0339        	call	_Lcd_Print_String
4660  0f16 200c          	jra	L1631
4661  0f18               L1102:
4662                     ; 592 								Lcd_Set_Cursor(2,0);
4664  0f18 ae0200        	ldw	x,#512
4665  0f1b cd0299        	call	_Lcd_Set_Cursor
4667                     ; 593 								Lcd_Print_String("   ");
4669  0f1e ae01fd        	ldw	x,#L331
4670  0f21 cd0339        	call	_Lcd_Print_String
4672  0f24               L1631:
4673                     ; 595 }
4676  0f24 81            	ret
4734                     ; 597 void Send_I2C_Buffer(uint8_t device_address, uint8_t *data, uint8_t length) {
4735                     	switch	.text
4736  0f25               _Send_I2C_Buffer:
4738  0f25 88            	push	a
4739       00000000      OFST:	set	0
4742                     ; 598     SW_I2C_start();
4744  0f26 cd0000        	call	_SW_I2C_start
4746                     ; 599     SW_I2C_write(device_address);
4748  0f29 7b01          	ld	a,(OFST+1,sp)
4749  0f2b cd0000        	call	_SW_I2C_write
4751                     ; 600     if (SW_I2C_wait_ACK()) {
4753  0f2e cd0000        	call	_SW_I2C_wait_ACK
4755  0f31 4d            	tnz	a
4756  0f32 2705          	jreq	L5502
4757                     ; 601         SW_I2C_stop(); 
4759  0f34 cd0000        	call	_SW_I2C_stop
4761                     ; 602         return;
4764  0f37 84            	pop	a
4765  0f38 81            	ret
4766  0f39               L5502:
4767                     ; 604     for (l = 0; l < length; l++) {  
4769  0f39 3f12          	clr	_l
4771  0f3b 2018          	jra	L3602
4772  0f3d               L7502:
4773                     ; 605         SW_I2C_write(data[l]);  
4775  0f3d b612          	ld	a,_l
4776  0f3f 5f            	clrw	x
4777  0f40 97            	ld	xl,a
4778  0f41 72fb04        	addw	x,(OFST+4,sp)
4779  0f44 f6            	ld	a,(x)
4780  0f45 cd0000        	call	_SW_I2C_write
4782                     ; 606         if (SW_I2C_wait_ACK()) {
4784  0f48 cd0000        	call	_SW_I2C_wait_ACK
4786  0f4b 4d            	tnz	a
4787  0f4c 2705          	jreq	L7602
4788                     ; 607             SW_I2C_stop();  
4790  0f4e cd0000        	call	_SW_I2C_stop
4792                     ; 608             return;
4795  0f51 84            	pop	a
4796  0f52 81            	ret
4797  0f53               L7602:
4798                     ; 604     for (l = 0; l < length; l++) {  
4800  0f53 3c12          	inc	_l
4801  0f55               L3602:
4804  0f55 b612          	ld	a,_l
4805  0f57 1106          	cp	a,(OFST+6,sp)
4806  0f59 25e2          	jrult	L7502
4807                     ; 611     SW_I2C_stop();  
4809  0f5b cd0000        	call	_SW_I2C_stop
4811                     ; 612 }
4814  0f5e 84            	pop	a
4815  0f5f 81            	ret
4846                     	switch	.const
4847  0012               L221:
4848  0012 00000032      	dc.l	50
4849  0016               L421:
4850  0016 000002f2      	dc.l	754
4851  001a               L621:
4852  001a 000251c0      	dc.l	152000
4853  001e               L031:
4854  001e 0006ab08      	dc.l	437000
4855                     ; 614 void Radio_Frequency(void) {
4856                     	switch	.text
4857  0f60               _Radio_Frequency:
4861                     ; 615     freqkhz = (uint32_t)(frec * 1000);
4863  0f60 ae0021        	ldw	x,#_frec
4864  0f63 cd0000        	call	c_ltor
4866  0f66 ae004b        	ldw	x,#L5012
4867  0f69 cd0000        	call	c_fmul
4869  0f6c cd0000        	call	c_ftol
4871  0f6f ae001d        	ldw	x,#_freqkhz
4872  0f72 cd0000        	call	c_rtol
4874                     ; 616     freqB = (freqkhz / 50) + 754;// z výpoctu: Frekvence ladení v kHz/krok ladení + IF frekvence v kHz, napr. 38kHz/krok ladení
4876  0f75 ae001d        	ldw	x,#_freqkhz
4877  0f78 cd0000        	call	c_ltor
4879  0f7b ae0012        	ldw	x,#L221
4880  0f7e cd0000        	call	c_ludv
4882  0f81 ae0016        	ldw	x,#L421
4883  0f84 cd0000        	call	c_ladd
4885  0f87 be02          	ldw	x,c_lreg+2
4886  0f89 bf1b          	ldw	_freqB,x
4887                     ; 618     if (freqkhz < 152000) {
4889  0f8b ae001d        	ldw	x,#_freqkhz
4890  0f8e cd0000        	call	c_ltor
4892  0f91 ae001a        	ldw	x,#L621
4893  0f94 cd0000        	call	c_lcmp
4895  0f97 2406          	jruge	L1112
4896                     ; 619         bb = 0b00000001;
4898  0f99 3501001a      	mov	_bb,#1
4900  0f9d 2018          	jra	L3112
4901  0f9f               L1112:
4902                     ; 620     } else if (freqkhz < 437000) {
4904  0f9f ae001d        	ldw	x,#_freqkhz
4905  0fa2 cd0000        	call	c_ltor
4907  0fa5 ae001e        	ldw	x,#L031
4908  0fa8 cd0000        	call	c_lcmp
4910  0fab 2406          	jruge	L5112
4911                     ; 621         bb = 0b00000010;
4913  0fad 3502001a      	mov	_bb,#2
4915  0fb1 2004          	jra	L3112
4916  0fb3               L5112:
4917                     ; 623         bb = 0b00001000;
4919  0fb3 3508001a      	mov	_bb,#8
4920  0fb7               L3112:
4921                     ; 625     cb = 0b11000000 | ((sb & 1) << 0); 
4923  0fb7 b60d          	ld	a,_sb+1
4924  0fb9 a401          	and	a,#1
4925  0fbb aac0          	or	a,#192
4926  0fbd b719          	ld	_cb,a
4927                     ; 627     buf1[0] = (freqB >> 8) & 0x7F;  
4929  0fbf b61b          	ld	a,_freqB
4930  0fc1 a47f          	and	a,#127
4931  0fc3 b715          	ld	_buf1,a
4932                     ; 628     buf1[1] = freqB & 0xFF;         
4934  0fc5 b61c          	ld	a,_freqB+1
4935  0fc7 a4ff          	and	a,#255
4936  0fc9 b716          	ld	_buf1+1,a
4937                     ; 629     buf1[2] = cb;                   
4939  0fcb 451917        	mov	_buf1+2,_cb
4940                     ; 630     buf1[3] = bb;                 
4942  0fce 451a18        	mov	_buf1+3,_bb
4943                     ; 632     Send_I2C_Buffer(TDA6508A_I2C_WRITE, buf1, 4);
4945  0fd1 4b04          	push	#4
4946  0fd3 ae0015        	ldw	x,#_buf1
4947  0fd6 89            	pushw	x
4948  0fd7 a6c0          	ld	a,#192
4949  0fd9 cd0f25        	call	_Send_I2C_Buffer
4951  0fdc 5b03          	addw	sp,#3
4952                     ; 633 }
4955  0fde 81            	ret
4980                     ; 635 void Stand_By_Mode(void){
4981                     	switch	.text
4982  0fdf               _Stand_By_Mode:
4986                     ; 636 	buf2[0] = 0b11001000;  //cb             
4988  0fdf 35c80013      	mov	_buf2,#200
4989                     ; 637 	buf2[1] = 0b00000011;  //bb 
4991  0fe3 35030014      	mov	_buf2+1,#3
4992                     ; 638 	Send_I2C_Buffer(TDA6508A_I2C_WRITE, buf2, 2);
4994  0fe7 4b02          	push	#2
4995  0fe9 ae0013        	ldw	x,#_buf2
4996  0fec 89            	pushw	x
4997  0fed a6c0          	ld	a,#192
4998  0fef cd0f25        	call	_Send_I2C_Buffer
5000  0ff2 5b03          	addw	sp,#3
5001                     ; 639 }
5004  0ff4 81            	ret
5034                     ; 641 void Print_Frequency(void) {
5035                     	switch	.text
5036  0ff5               _Print_Frequency:
5040                     ; 642     if (frec >= 100.0)  {
5042  0ff5 9c            	rvf
5043  0ff6 ae0021        	ldw	x,#_frec
5044  0ff9 cd0000        	call	c_ltor
5046  0ffc ae0047        	ldw	x,#L7412
5047  0fff cd0000        	call	c_fcmp
5049  1002 2f0c          	jrslt	L1412
5050                     ; 643         Lcd_Print_Int_At1(2, 5, frec1);
5052  1004 be25          	ldw	x,_frec1
5053  1006 89            	pushw	x
5054  1007 ae0205        	ldw	x,#517
5055  100a cd0087        	call	_Lcd_Print_Int_At1
5057  100d 85            	popw	x
5059  100e 2025          	jra	L3512
5060  1010               L1412:
5061                     ; 645 		else if (frec < 100.0) {
5063  1010 9c            	rvf
5064  1011 ae0021        	ldw	x,#_frec
5065  1014 cd0000        	call	c_ltor
5067  1017 ae0047        	ldw	x,#L7412
5068  101a cd0000        	call	c_fcmp
5070  101d 2e16          	jrsge	L3512
5071                     ; 646 				Lcd_Set_Cursor(2, 5);
5073  101f ae0205        	ldw	x,#517
5074  1022 cd0299        	call	_Lcd_Set_Cursor
5076                     ; 647 				Lcd_Print_String(" ");
5078  1025 ae01fb        	ldw	x,#L112
5079  1028 cd0339        	call	_Lcd_Print_String
5081                     ; 648         Lcd_Print_Int_At1(2, 6, frec1);
5083  102b be25          	ldw	x,_frec1
5084  102d 89            	pushw	x
5085  102e ae0206        	ldw	x,#518
5086  1031 cd0087        	call	_Lcd_Print_Int_At1
5088  1034 85            	popw	x
5089  1035               L3512:
5090                     ; 650 		Lcd_Set_Cursor(2, 8);
5092  1035 ae0208        	ldw	x,#520
5093  1038 cd0299        	call	_Lcd_Set_Cursor
5095                     ; 651 		Lcd_Print_String(".");
5097  103b ae0045        	ldw	x,#L7512
5098  103e cd0339        	call	_Lcd_Print_String
5100                     ; 652 		Lcd_Print_Int_At2(2, 9, frec2);
5102  1041 5f            	clrw	x
5103  1042 b627          	ld	a,_frec2
5104  1044 2a01          	jrpl	L631
5105  1046 53            	cplw	x
5106  1047               L631:
5107  1047 97            	ld	xl,a
5108  1048 89            	pushw	x
5109  1049 ae0209        	ldw	x,#521
5110  104c cd00fd        	call	_Lcd_Print_Int_At2
5112  104f 85            	popw	x
5113                     ; 653 }
5116  1050 81            	ret
5142                     ; 655 void Update_Frequency(void) {
5143                     	switch	.text
5144  1051               _Update_Frequency:
5146  1051 5204          	subw	sp,#4
5147       00000004      OFST:	set	4
5150                     ; 656     frec = frec1 + (frec2 / 10.0);
5152  1053 be25          	ldw	x,_frec1
5153  1055 cd0000        	call	c_uitof
5155  1058 96            	ldw	x,sp
5156  1059 1c0001        	addw	x,#OFST-3
5157  105c cd0000        	call	c_rtol
5160  105f 5f            	clrw	x
5161  1060 b627          	ld	a,_frec2
5162  1062 2a01          	jrpl	L241
5163  1064 53            	cplw	x
5164  1065               L241:
5165  1065 97            	ld	xl,a
5166  1066 cd0000        	call	c_itof
5168  1069 ae0160        	ldw	x,#L117
5169  106c cd0000        	call	c_fdiv
5171  106f 96            	ldw	x,sp
5172  1070 1c0001        	addw	x,#OFST-3
5173  1073 cd0000        	call	c_fadd
5175  1076 ae0021        	ldw	x,#_frec
5176  1079 cd0000        	call	c_rtol
5178                     ; 657     if (frec2 > 9) {
5180  107c 9c            	rvf
5181  107d b627          	ld	a,_frec2
5182  107f a10a          	cp	a,#10
5183  1081 2f09          	jrslt	L1712
5184                     ; 658         frec1++;
5186  1083 be25          	ldw	x,_frec1
5187  1085 1c0001        	addw	x,#1
5188  1088 bf25          	ldw	_frec1,x
5189                     ; 659         frec2 = 0;
5191  108a 3f27          	clr	_frec2
5192  108c               L1712:
5193                     ; 661     if (frec2 < 0) {
5195  108c 9c            	rvf
5196  108d b627          	ld	a,_frec2
5197  108f a100          	cp	a,#0
5198  1091 2e0b          	jrsge	L3712
5199                     ; 662         frec1--;
5201  1093 be25          	ldw	x,_frec1
5202  1095 1d0001        	subw	x,#1
5203  1098 bf25          	ldw	_frec1,x
5204                     ; 663         frec2 = 9;
5206  109a 35090027      	mov	_frec2,#9
5207  109e               L3712:
5208                     ; 665 }
5211  109e 5b04          	addw	sp,#4
5212  10a0 81            	ret
5243                     ; 667 void Frequency_Limits(void) {
5244                     	switch	.text
5245  10a1               _Frequency_Limits:
5249                     ; 668     if (frec > 870.0) {
5251  10a1 9c            	rvf
5252  10a2 ae0021        	ldw	x,#_frec
5253  10a5 cd0000        	call	c_ltor
5255  10a8 ae0041        	ldw	x,#L3122
5256  10ab cd0000        	call	c_fcmp
5258  10ae 2d29          	jrsle	L5022
5259                     ; 669         Lcd_Set_Cursor(2, 15);
5261  10b0 ae020f        	ldw	x,#527
5262  10b3 cd0299        	call	_Lcd_Set_Cursor
5264                     ; 670         Lcd_Print_String("L");
5266  10b6 ae003f        	ldw	x,#L7122
5267  10b9 cd0339        	call	_Lcd_Print_String
5269                     ; 671         delay_ms(1500);
5271  10bc ae05dc        	ldw	x,#1500
5272  10bf cd0000        	call	_delay_ms
5274                     ; 672         frec2 = 0;
5276  10c2 3f27          	clr	_frec2
5277                     ; 673         frec1 = 870;
5279  10c4 ae0366        	ldw	x,#870
5280  10c7 bf25          	ldw	_frec1,x
5281                     ; 674         frec = 870.0;
5283  10c9 ce0043        	ldw	x,L3122+2
5284  10cc bf23          	ldw	_frec+2,x
5285  10ce ce0041        	ldw	x,L3122
5286  10d1 bf21          	ldw	_frec,x
5287                     ; 675 				Radio_Frequency();
5289  10d3 cd0f60        	call	_Radio_Frequency
5291                     ; 676         Print_Frequency();
5293  10d6 cd0ff5        	call	_Print_Frequency
5295  10d9               L5022:
5296                     ; 678     if (frec < 45.0) {
5298  10d9 9c            	rvf
5299  10da ae0021        	ldw	x,#_frec
5300  10dd cd0000        	call	c_ltor
5302  10e0 ae003b        	ldw	x,#L7222
5303  10e3 cd0000        	call	c_fcmp
5305  10e6 2e2b          	jrsge	L1222
5306                     ; 679         Lcd_Set_Cursor(2, 15);
5308  10e8 ae020f        	ldw	x,#527
5309  10eb cd0299        	call	_Lcd_Set_Cursor
5311                     ; 680         Lcd_Print_String("L");
5313  10ee ae003f        	ldw	x,#L7122
5314  10f1 cd0339        	call	_Lcd_Print_String
5316                     ; 681         delay_ms(1500);
5318  10f4 ae05dc        	ldw	x,#1500
5319  10f7 cd0000        	call	_delay_ms
5321                     ; 682         frec2 = 0;
5323  10fa 3f27          	clr	_frec2
5324                     ; 683         frec1 = 45;
5326  10fc ae002d        	ldw	x,#45
5327  10ff bf25          	ldw	_frec1,x
5328                     ; 684         frec = 45.0;
5330  1101 ce003d        	ldw	x,L7222+2
5331  1104 bf23          	ldw	_frec+2,x
5332  1106 ce003b        	ldw	x,L7222
5333  1109 bf21          	ldw	_frec,x
5334                     ; 685 				Radio_Frequency();
5336  110b cd0f60        	call	_Radio_Frequency
5338                     ; 686         Print_Frequency();
5340  110e cd0ff5        	call	_Print_Frequency
5343  1111 200c          	jra	L3322
5344  1113               L1222:
5345                     ; 688         Lcd_Set_Cursor(2, 15);
5347  1113 ae020f        	ldw	x,#527
5348  1116 cd0299        	call	_Lcd_Set_Cursor
5350                     ; 689         Lcd_Print_String(" ");
5352  1119 ae01fb        	ldw	x,#L112
5353  111c cd0339        	call	_Lcd_Print_String
5355  111f               L3322:
5356                     ; 691 }
5359  111f 81            	ret
5406                     ; 693 uint8_t Get_Keypad_Key(void) {
5407                     	switch	.text
5408  1120               _Get_Keypad_Key:
5410  1120 89            	pushw	x
5411       00000002      OFST:	set	2
5414                     ; 695     GPIO_WriteHigh(KS_PO, KS1_P | KS2_P | KS3_P);
5416  1121 4b0e          	push	#14
5417  1123 ae5014        	ldw	x,#20500
5418  1126 cd0000        	call	_GPIO_WriteHigh
5420  1129 84            	pop	a
5421                     ; 696     for (col = 0; col < 3; col++) {
5423  112a 0f02          	clr	(OFST+0,sp)
5425  112c               L5722:
5426                     ; 697         GPIO_WriteHigh(KS_PO, KS1_P | KS2_P | KS3_P);
5428  112c 4b0e          	push	#14
5429  112e ae5014        	ldw	x,#20500
5430  1131 cd0000        	call	_GPIO_WriteHigh
5432  1134 84            	pop	a
5433                     ; 698         switch (col) {
5435  1135 7b02          	ld	a,(OFST+0,sp)
5437                     ; 701             case 2: GPIO_WriteLow(KS_PO, KS3_P); break;
5438  1137 4d            	tnz	a
5439  1138 2708          	jreq	L5322
5440  113a 4a            	dec	a
5441  113b 2710          	jreq	L7322
5442  113d 4a            	dec	a
5443  113e 2718          	jreq	L1422
5444  1140 201f          	jra	L5032
5445  1142               L5322:
5446                     ; 699             case 0: GPIO_WriteLow(KS_PO, KS1_P); break;
5448  1142 4b04          	push	#4
5449  1144 ae5014        	ldw	x,#20500
5450  1147 cd0000        	call	_GPIO_WriteLow
5452  114a 84            	pop	a
5455  114b 2014          	jra	L5032
5456  114d               L7322:
5457                     ; 700             case 1: GPIO_WriteLow(KS_PO, KS2_P); break;
5459  114d 4b02          	push	#2
5460  114f ae5014        	ldw	x,#20500
5461  1152 cd0000        	call	_GPIO_WriteLow
5463  1155 84            	pop	a
5466  1156 2009          	jra	L5032
5467  1158               L1422:
5468                     ; 701             case 2: GPIO_WriteLow(KS_PO, KS3_P); break;
5470  1158 4b08          	push	#8
5471  115a ae5014        	ldw	x,#20500
5472  115d cd0000        	call	_GPIO_WriteLow
5474  1160 84            	pop	a
5477  1161               L5032:
5478                     ; 703         delay_ms(12); 
5480  1161 ae000c        	ldw	x,#12
5481  1164 cd0000        	call	_delay_ms
5483                     ; 704         row_state = GPIO_ReadInputData(KR_PO) & 0b11101000;
5485  1167 ae500a        	ldw	x,#20490
5486  116a cd0000        	call	_GPIO_ReadInputData
5488  116d a4e8          	and	a,#232
5489  116f 6b01          	ld	(OFST-1,sp),a
5491                     ; 705         if (row_state != 0b11101000) {
5493  1171 7b01          	ld	a,(OFST-1,sp)
5494  1173 a1e8          	cp	a,#232
5495  1175 272f          	jreq	L7032
5496                     ; 706             switch (row_state) {
5498  1177 7b01          	ld	a,(OFST-1,sp)
5500                     ; 710                 case 0b01101000: return (col * 4) + 3;
5501  1179 a068          	sub	a,#104
5502  117b 2721          	jreq	L1522
5503  117d a040          	sub	a,#64
5504  117f 2715          	jreq	L7422
5505  1181 a020          	sub	a,#32
5506  1183 270a          	jreq	L5422
5507  1185 a018          	sub	a,#24
5508  1187 261d          	jrne	L7032
5509                     ; 707                 case 0b11100000: return (col * 4) + 0;
5511  1189 7b02          	ld	a,(OFST+0,sp)
5512  118b 48            	sll	a
5513  118c 48            	sll	a
5515  118d 2005          	jra	L051
5516  118f               L5422:
5517                     ; 708                 case 0b11001000: return (col * 4) + 1;
5519  118f 7b02          	ld	a,(OFST+0,sp)
5520  1191 48            	sll	a
5521  1192 48            	sll	a
5522  1193 4c            	inc	a
5524  1194               L051:
5526  1194 85            	popw	x
5527  1195 81            	ret
5528  1196               L7422:
5529                     ; 709                 case 0b10101000: return (col * 4) + 2;
5531  1196 7b02          	ld	a,(OFST+0,sp)
5532  1198 48            	sll	a
5533  1199 48            	sll	a
5534  119a ab02          	add	a,#2
5536  119c 20f6          	jra	L051
5537  119e               L1522:
5538                     ; 710                 case 0b01101000: return (col * 4) + 3;
5540  119e 7b02          	ld	a,(OFST+0,sp)
5541  11a0 48            	sll	a
5542  11a1 48            	sll	a
5543  11a2 ab03          	add	a,#3
5545  11a4 20ee          	jra	L051
5546  11a6               L3132:
5547  11a6               L7032:
5548                     ; 696     for (col = 0; col < 3; col++) {
5550  11a6 0c02          	inc	(OFST+0,sp)
5554  11a8 7b02          	ld	a,(OFST+0,sp)
5555  11aa a103          	cp	a,#3
5556  11ac 2403cc112c    	jrult	L5722
5557                     ; 714     return 255;
5559  11b1 a6ff          	ld	a,#255
5561  11b3 20df          	jra	L051
5629                     ; 717 void Handle_Keypad_Input(void) {
5630                     	switch	.text
5631  11b5               _Handle_Keypad_Input:
5633  11b5 5205          	subw	sp,#5
5634       00000005      OFST:	set	5
5637                     ; 718 readstatus = Get_Keypad_Key();
5639  11b7 cd1120        	call	_Get_Keypad_Key
5641  11ba b72e          	ld	_readstatus,a
5642                     ; 719 key = keypad_chars[readstatus];
5644  11bc b62e          	ld	a,_readstatus
5645  11be 5f            	clrw	x
5646  11bf 97            	ld	xl,a
5647  11c0 d60006        	ld	a,(_keypad_chars,x)
5648  11c3 b709          	ld	_key,a
5649                     ; 720 			if (key == '*' | skip_verification==1) {
5651  11c5 b609          	ld	a,_key
5652  11c7 a12a          	cp	a,#42
5653  11c9 270a          	jreq	L3432
5655  11cb be2c          	ldw	x,_skip_verification
5656  11cd a30001        	cpw	x,#1
5657  11d0 2703          	jreq	L261
5658  11d2 cc134a        	jp	L7332
5659  11d5               L261:
5660  11d5               L3432:
5661                     ; 722                 input_error = 0;
5663  11d5 3f0a          	clr	_input_error
5664                     ; 723 								Lcd_Set_Cursor(2, 16);
5666  11d7 ae0210        	ldw	x,#528
5667  11da cd0299        	call	_Lcd_Set_Cursor
5669                     ; 724 								Lcd_Print_String("K");
5671  11dd ae0039        	ldw	x,#L1532
5672  11e0 cd0339        	call	_Lcd_Print_String
5674                     ; 725 								Lcd_Print_String("     ");
5676  11e3 ae0033        	ldw	x,#L3532
5677  11e6 cd0339        	call	_Lcd_Print_String
5679                     ; 726                 Lcd_Set_Cursor(2, 5);
5681  11e9 ae0205        	ldw	x,#517
5682  11ec cd0299        	call	_Lcd_Set_Cursor
5684                     ; 727                 Lcd_Print_String("___._ MHz");
5686  11ef ae0029        	ldw	x,#L5532
5687  11f2 cd0339        	call	_Lcd_Print_String
5689                     ; 728                 memset(new_frec1, 0, sizeof(new_frec1));
5691  11f5 ae0004        	ldw	x,#4
5692  11f8               L451:
5693  11f8 6f0d          	clr	(_new_frec1-1,x)
5694  11fa 5a            	decw	x
5695  11fb 26fb          	jrne	L451
5696                     ; 729                 new_frec2 = '0';
5698  11fd 3530000d      	mov	_new_frec2,#48
5699                     ; 730                 input_stage = 1;  
5701  1201 3501000c      	mov	_input_stage,#1
5702                     ; 731                 input_position = 5;
5704  1205 3505000b      	mov	_input_position,#5
5705                     ; 732                 Lcd_Set_Cursor(2, 8);
5707  1209 ae0208        	ldw	x,#520
5708  120c cd0299        	call	_Lcd_Set_Cursor
5710                     ; 733                 Lcd_Print_Char('.');
5712  120f a62e          	ld	a,#46
5713  1211 cd02e4        	call	_Lcd_Print_Char
5715  1214               L7532:
5716                     ; 735                     uint8_t key_read = Get_Keypad_Key();
5718  1214 cd1120        	call	_Get_Keypad_Key
5720  1217 6b05          	ld	(OFST+0,sp),a
5722                     ; 736                     if (key_read < 12) {
5724  1219 7b05          	ld	a,(OFST+0,sp)
5725  121b a10c          	cp	a,#12
5726  121d 2503          	jrult	L461
5727  121f cc1336        	jp	L3632
5728  1222               L461:
5729                     ; 737                         char key_input = keypad_chars[key_read];
5731  1222 7b05          	ld	a,(OFST+0,sp)
5732  1224 5f            	clrw	x
5733  1225 97            	ld	xl,a
5734  1226 d60006        	ld	a,(_keypad_chars,x)
5735  1229 6b05          	ld	(OFST+0,sp),a
5737                     ; 738                         if (key_input >= '0' && key_input <= '9') {
5739  122b 7b05          	ld	a,(OFST+0,sp)
5740  122d a130          	cp	a,#48
5741  122f 256a          	jrult	L5632
5743  1231 7b05          	ld	a,(OFST+0,sp)
5744  1233 a13a          	cp	a,#58
5745  1235 2464          	jruge	L5632
5746                     ; 739                             if (input_stage == 1 && strlen(new_frec1) < 3) {
5748  1237 b60c          	ld	a,_input_stage
5749  1239 a101          	cp	a,#1
5750  123b 263f          	jrne	L7632
5752  123d ae000e        	ldw	x,#_new_frec1
5753  1240 cd0000        	call	_strlen
5755  1243 a30003        	cpw	x,#3
5756  1246 2434          	jruge	L7632
5757                     ; 740                                 new_frec1[strlen(new_frec1)] = key_input;
5759  1248 ae000e        	ldw	x,#_new_frec1
5760  124b cd0000        	call	_strlen
5762  124e 7b05          	ld	a,(OFST+0,sp)
5763  1250 e70e          	ld	(_new_frec1,x),a
5764                     ; 741                                 Lcd_Set_Cursor(2, input_position);
5766  1252 b60b          	ld	a,_input_position
5767  1254 ae0200        	ldw	x,#512
5768  1257 97            	ld	xl,a
5769  1258 cd0299        	call	_Lcd_Set_Cursor
5771                     ; 742                                 Lcd_Print_Char(key_input);
5773  125b 7b05          	ld	a,(OFST+0,sp)
5774  125d cd02e4        	call	_Lcd_Print_Char
5776                     ; 743                                 input_position++; 
5778  1260 3c0b          	inc	_input_position
5779                     ; 744                                 if (strlen(new_frec1) == 3) {
5781  1262 ae000e        	ldw	x,#_new_frec1
5782  1265 cd0000        	call	_strlen
5784  1268 a30003        	cpw	x,#3
5785  126b 2703          	jreq	L661
5786  126d cc1336        	jp	L3632
5787  1270               L661:
5788                     ; 745                                     input_stage = 2;
5790  1270 3502000c      	mov	_input_stage,#2
5791                     ; 746                                     input_position = 9;
5793  1274 3509000b      	mov	_input_position,#9
5794  1278 ac361336      	jpf	L3632
5795  127c               L7632:
5796                     ; 749                             else if (input_stage == 2) {
5798  127c b60c          	ld	a,_input_stage
5799  127e a102          	cp	a,#2
5800  1280 2703          	jreq	L071
5801  1282 cc1336        	jp	L3632
5802  1285               L071:
5803                     ; 750                                 new_frec2 = key_input;
5805  1285 7b05          	ld	a,(OFST+0,sp)
5806  1287 b70d          	ld	_new_frec2,a
5807                     ; 751                                 Lcd_Set_Cursor(2, input_position);
5809  1289 b60b          	ld	a,_input_position
5810  128b ae0200        	ldw	x,#512
5811  128e 97            	ld	xl,a
5812  128f cd0299        	call	_Lcd_Set_Cursor
5814                     ; 752                                 Lcd_Print_Char(key_input);
5816  1292 7b05          	ld	a,(OFST+0,sp)
5817  1294 cd02e4        	call	_Lcd_Print_Char
5819  1297 ac361336      	jpf	L3632
5820  129b               L5632:
5821                     ; 755                         else if (key_input == '#') {
5823  129b 7b05          	ld	a,(OFST+0,sp)
5824  129d a123          	cp	a,#35
5825  129f 2703          	jreq	L271
5826  12a1 cc1336        	jp	L3632
5827  12a4               L271:
5828                     ; 756                             frec1 = atoi(new_frec1);
5830  12a4 ae000e        	ldw	x,#_new_frec1
5831  12a7 cd0000        	call	_atoi
5833  12aa bf25          	ldw	_frec1,x
5834                     ; 757                             frec2 = new_frec2 - '0';
5836  12ac b60d          	ld	a,_new_frec2
5837  12ae a030          	sub	a,#48
5838  12b0 b727          	ld	_frec2,a
5839                     ; 758                             if (frec1 > 870) {
5841  12b2 be25          	ldw	x,_frec1
5842  12b4 a30367        	cpw	x,#871
5843  12b7 2506          	jrult	L3042
5844                     ; 759                                 input_error = 1;  
5846  12b9 3501000a      	mov	_input_error,#1
5847                     ; 760                                 break;  
5849  12bd 200b          	jra	L1632
5850  12bf               L3042:
5851                     ; 762 														if (frec1 < 45) {
5853  12bf be25          	ldw	x,_frec1
5854  12c1 a3002d        	cpw	x,#45
5855  12c4 241c          	jruge	L5042
5856                     ; 763                                 input_error = 1;
5858  12c6 3501000a      	mov	_input_error,#1
5859                     ; 764                                 break; 
5860  12ca               L1632:
5861                     ; 781                 if (input_error) {
5863  12ca 3d0a          	tnz	_input_error
5864  12cc 2772          	jreq	L5432
5865                     ; 782                     Lcd_Set_Cursor(2, 5);
5867  12ce ae0205        	ldw	x,#517
5868  12d1 cd0299        	call	_Lcd_Set_Cursor
5870                     ; 783                     Lcd_Print_String("CHYBA!");
5872  12d4 ae0022        	ldw	x,#L1142
5873  12d7 cd0339        	call	_Lcd_Print_String
5875                     ; 784                     delay_ms(2000);
5877  12da ae07d0        	ldw	x,#2000
5878  12dd cd0000        	call	_delay_ms
5880  12e0 205e          	jra	L5432
5881  12e2               L5042:
5882                     ; 766                             frec = frec1 + (frec2 / 10.0);
5884  12e2 be25          	ldw	x,_frec1
5885  12e4 cd0000        	call	c_uitof
5887  12e7 96            	ldw	x,sp
5888  12e8 1c0001        	addw	x,#OFST-4
5889  12eb cd0000        	call	c_rtol
5892  12ee 5f            	clrw	x
5893  12ef b627          	ld	a,_frec2
5894  12f1 2a01          	jrpl	L651
5895  12f3 53            	cplw	x
5896  12f4               L651:
5897  12f4 97            	ld	xl,a
5898  12f5 cd0000        	call	c_itof
5900  12f8 ae0160        	ldw	x,#L117
5901  12fb cd0000        	call	c_fdiv
5903  12fe 96            	ldw	x,sp
5904  12ff 1c0001        	addw	x,#OFST-4
5905  1302 cd0000        	call	c_fadd
5907  1305 ae0021        	ldw	x,#_frec
5908  1308 cd0000        	call	c_rtol
5910                     ; 767                             force_lcd_update = 1;
5912  130b ae0001        	ldw	x,#1
5913  130e bf00          	ldw	_force_lcd_update,x
5914                     ; 768 														Lcd_Set_Cursor(2, 16);
5916  1310 ae0210        	ldw	x,#528
5917  1313 cd0299        	call	_Lcd_Set_Cursor
5919                     ; 769 														Lcd_Print_String(" ");
5921  1316 ae01fb        	ldw	x,#L112
5922  1319 cd0339        	call	_Lcd_Print_String
5924                     ; 770 														Lcd_Set_Cursor(2, 5);
5926  131c ae0205        	ldw	x,#517
5927  131f cd0299        	call	_Lcd_Set_Cursor
5929                     ; 771 														Lcd_Print_String("     ");
5931  1322 ae0033        	ldw	x,#L3532
5932  1325 cd0339        	call	_Lcd_Print_String
5934                     ; 772                             Radio_Frequency();
5936  1328 cd0f60        	call	_Radio_Frequency
5938                     ; 773                             Print_Frequency();
5940  132b cd0ff5        	call	_Print_Frequency
5942                     ; 774 														LCD_Dec_Fix();
5944  132e cd0b3f        	call	_LCD_Dec_Fix
5946                     ; 775 														skip_verification = 0;
5948  1331 5f            	clrw	x
5949  1332 bf2c          	ldw	_skip_verification,x
5950                     ; 776                             return; 
5952  1334 2011          	jra	L061
5953  1336               L3632:
5954                     ; 779                     delay_ms(100);
5956  1336 ae0064        	ldw	x,#100
5957  1339 cd0000        	call	_delay_ms
5960  133c ac141214      	jpf	L7532
5961  1340               L5432:
5962                     ; 786             } while (input_error);
5964  1340 3d0a          	tnz	_input_error
5965  1342 2703          	jreq	L471
5966  1344 cc11d5        	jp	L3432
5967  1347               L471:
5969                     ; 791 }		
5970  1347               L061:
5973  1347 5b05          	addw	sp,#5
5974  1349 81            	ret
5975  134a               L7332:
5976                     ; 789 				return;
5978  134a 20fb          	jra	L061
6013                     ; 803 void assert_failed(u8* file, u32 line)
6013                     ; 804 { 
6014                     	switch	.text
6015  134c               _assert_failed:
6019  134c               L3342:
6020  134c 20fe          	jra	L3342
6327                     	xdef	_EEPROM_Load_Slot
6328                     	xdef	_EEPROM_Store_Slot
6329                     	xdef	_main
6330                     	switch	.ubsct
6331  0000               _addr_frec2:
6332  0000 0000          	ds.b	2
6333                     	xdef	_addr_frec2
6334  0002               _addr_frec1:
6335  0002 0000          	ds.b	2
6336                     	xdef	_addr_frec1
6337  0004               _addr_flag:
6338  0004 0000          	ds.b	2
6339                     	xdef	_addr_flag
6340                     	xdef	_isStored2
6341                     	xdef	_isStored1
6342  0006               _adc:
6343  0006 0000          	ds.b	2
6344                     	xdef	_adc
6345  0008               _status_byte:
6346  0008 00            	ds.b	1
6347                     	xdef	_status_byte
6348  0009               _key:
6349  0009 00            	ds.b	1
6350                     	xdef	_key
6351  000a               _input_error:
6352  000a 00            	ds.b	1
6353                     	xdef	_input_error
6354  000b               _input_position:
6355  000b 00            	ds.b	1
6356                     	xdef	_input_position
6357  000c               _input_stage:
6358  000c 00            	ds.b	1
6359                     	xdef	_input_stage
6360  000d               _new_frec2:
6361  000d 00            	ds.b	1
6362                     	xdef	_new_frec2
6363  000e               _new_frec1:
6364  000e 00000000      	ds.b	4
6365                     	xdef	_new_frec1
6366  0012               _l:
6367  0012 00            	ds.b	1
6368                     	xdef	_l
6369  0013               _buf2:
6370  0013 0000          	ds.b	2
6371                     	xdef	_buf2
6372  0015               _buf1:
6373  0015 00000000      	ds.b	4
6374                     	xdef	_buf1
6375  0019               _cb:
6376  0019 00            	ds.b	1
6377                     	xdef	_cb
6378  001a               _bb:
6379  001a 00            	ds.b	1
6380                     	xdef	_bb
6381  001b               _freqB:
6382  001b 0000          	ds.b	2
6383                     	xdef	_freqB
6384  001d               _freqkhz:
6385  001d 00000000      	ds.b	4
6386                     	xdef	_freqkhz
6387  0021               _frec:
6388  0021 00000000      	ds.b	4
6389                     	xdef	_frec
6390  0025               _frec1:
6391  0025 0000          	ds.b	2
6392                     	xdef	_frec1
6393  0027               _frec2:
6394  0027 00            	ds.b	1
6395                     	xdef	_frec2
6396                     	xdef	_Input_Clock
6397  0028               _lastCLKState:
6398  0028 00            	ds.b	1
6399                     	xdef	_lastCLKState
6400  0029               _c:
6401  0029 00            	ds.b	1
6402                     	xdef	_c
6403  002a               _cnt:
6404  002a 0000          	ds.b	2
6405                     	xdef	_cnt
6406                     	xdef	_sb
6407  002c               _skip_verification:
6408  002c 0000          	ds.b	2
6409                     	xdef	_skip_verification
6410                     	xdef	_encoder_done
6411  002e               _readstatus:
6412  002e 00            	ds.b	1
6413                     	xdef	_readstatus
6414                     	xdef	_LCD_Dec_Fix
6415                     	xdef	_Update_Memory_Indicator
6416                     	xdef	_Stored_In_Memory2
6417                     	xdef	_Stored_In_Memory1
6418                     	xdef	_Control_Byte_Settings
6419                     	xdef	_Handle_Keypad_Input
6420                     	xdef	_Get_Keypad_Key
6421                     	xdef	_Read_From_Tuner
6422                     	xdef	_Stand_By_Mode
6423                     	xdef	_Radio_Frequency
6424                     	xdef	_Update_Frequency
6425                     	xdef	_Print_Frequency
6426                     	xdef	_Additional_Info
6427                     	xdef	_Encoder_Read
6428                     	xdef	_Frequency_Limits
6429                     	xdef	_GPIO_Init_Buttons
6430                     	xdef	_GPIO_Init_Keypad
6431                     	xdef	_GPIO_Init_Encoder
6432                     	xdef	_Encoder_Mode
6433                     	xdef	_Load_Animation
6434                     	xdef	_Send_I2C_Buffer
6435                     	xdef	_keypad_chars
6436                     	xref	_atoi
6437                     	xref	_SW_I2C_wait_ACK
6438                     	xref	_SW_I2C_write
6439                     	xref	_SW_I2C_read
6440                     	xref	_SW_I2C_stop
6441                     	xref	_SW_I2C_start
6442                     	xref	_SW_I2C_init
6443  002f               _k:
6444  002f 00000000      	ds.b	4
6445                     	xdef	_k
6446  0033               _j:
6447  0033 00000000      	ds.b	4
6448                     	xdef	_j
6449  0037               _i:
6450  0037 00000000      	ds.b	4
6451                     	xdef	_i
6452                     	xdef	_force_lcd_update
6453                     	xdef	_Lcd_Print_Int_At2
6454                     	xdef	_Lcd_Print_Int_At1
6455                     	xdef	_int_to_string
6456                     	xdef	_Lcd_Print_String
6457                     	xdef	_Lcd_Set_Cursor
6458                     	xdef	_Lcd_Clear
6459                     	xdef	_Lcd_Print_Char
6460                     	xdef	_Lcd_Begin
6461                     	xdef	_Lcd_Cmd
6462                     	xdef	_Lcd_SetBit
6463                     	xref	_strlen
6464                     	xref	_init_milis
6465                     	xref	_delay_ms
6466                     	xdef	_assert_failed
6467                     	xref	_GPIO_ReadInputPin
6468                     	xref	_GPIO_ReadInputData
6469                     	xref	_GPIO_WriteLow
6470                     	xref	_GPIO_WriteHigh
6471                     	xref	_GPIO_Init
6472                     	xref	_FLASH_ReadByte
6473                     	xref	_FLASH_ProgramByte
6474                     	xref	_FLASH_EraseByte
6475                     	xref	_FLASH_Lock
6476                     	xref	_FLASH_Unlock
6477                     	xref	_CLK_HSIPrescalerConfig
6478                     	switch	.const
6479  0022               L1142:
6480  0022 434859424121  	dc.b	"CHYBA!",0
6481  0029               L5532:
6482  0029 5f5f5f2e5f20  	dc.b	"___._ MHz",0
6483  0033               L3532:
6484  0033 202020202000  	dc.b	"     ",0
6485  0039               L1532:
6486  0039 4b00          	dc.b	"K",0
6487  003b               L7222:
6488  003b 42340000      	dc.w	16948,0
6489  003f               L7122:
6490  003f 4c00          	dc.b	"L",0
6491  0041               L3122:
6492  0041 44598000      	dc.w	17497,-32768
6493  0045               L7512:
6494  0045 2e00          	dc.b	".",0
6495  0047               L7412:
6496  0047 42c80000      	dc.w	17096,0
6497  004b               L5012:
6498  004b 447a0000      	dc.w	17530,0
6499  004f               L3202:
6500  004f 344d00        	dc.b	"4M",0
6501  0052               L7102:
6502  0052 42919999      	dc.w	17041,-26215
6503  0056               L5002:
6504  0056 484c5300      	dc.b	"HLS",0
6505  005a               L1002:
6506  005a 428e9999      	dc.w	17038,-26215
6507  005e               L1771:
6508  005e 42873333      	dc.w	17031,13107
6509  0062               L7571:
6510  0062 364d00        	dc.b	"6M",0
6511  0065               L3571:
6512  0065 42580000      	dc.w	16984,0
6513  0069               L3471:
6514  0069 42480000      	dc.w	16968,0
6515  006d               L1371:
6516  006d 504d5200      	dc.b	"PMR",0
6517  0071               L5271:
6518  0071 43df1999      	dc.w	17375,6553
6519  0075               L5171:
6520  0075 43df0000      	dc.w	17375,0
6521  0079               L3071:
6522  0079 54455400      	dc.b	"TET",0
6523  007d               L7761:
6524  007d 43cd0000      	dc.w	17357,0
6525  0081               L1661:
6526  0081 57424c00      	dc.b	"WBL",0
6527  0085               L5561:
6528  0085 43cb0000      	dc.w	17355,0
6529  0089               L5461:
6530  0089 43c80000      	dc.w	17352,0
6531  008d               L3361:
6532  008d 332f3400      	dc.b	"3/4",0
6533  0091               L7261:
6534  0091 43dc0000      	dc.w	17372,0
6535  0095               L7161:
6536  0095 43d70000      	dc.w	17367,0
6537  0099               L5061:
6538  0099 495a5300      	dc.b	"IZS",0
6539  009d               L1061:
6540  009d 43200000      	dc.w	17184,0
6541  00a1               L7651:
6542  00a1 324d00        	dc.b	"2M",0
6543  00a4               L3651:
6544  00a4 43140000      	dc.w	17172,0
6545  00a8               L3551:
6546  00a8 43100000      	dc.w	17168,0
6547  00ac               L1451:
6548  00ac 49534d00      	dc.b	"ISM",0
6549  00b0               L5351:
6550  00b0 44590000      	dc.w	17497,0
6551  00b4               L5251:
6552  00b4 4455c000      	dc.w	17493,-16384
6553  00b8               L5151:
6554  00b8 43d97333      	dc.w	17369,29491
6555  00bc               L5051:
6556  00bc 43d88000      	dc.w	17368,-32768
6557  00c0               L7641:
6558  00c0 4d494c00      	dc.b	"MIL",0
6559  00c4               L3641:
6560  00c4 43be0000      	dc.w	17342,0
6561  00c8               L1541:
6562  00c8 44414200      	dc.b	"DAB",0
6563  00cc               L5441:
6564  00cc 436f0000      	dc.w	17263,0
6565  00d0               L5341:
6566  00d0 432e0000      	dc.w	17198,0
6567  00d4               L3241:
6568  00d4 53415400      	dc.b	"SAT",0
6569  00d8               L7141:
6570  00d8 430a0000      	dc.w	17162,0
6571  00dc               L7041:
6572  00dc 43090000      	dc.w	17161,0
6573  00e0               L5731:
6574  00e0 41495200      	dc.b	"AIR",0
6575  00e4               L1731:
6576  00e4 43080000      	dc.w	17160,0
6577  00e8               L7531:
6578  00e8 464d00        	dc.b	"FM",0
6579  00eb               L3531:
6580  00eb 42d80000      	dc.w	17112,0
6581  00ef               L3431:
6582  00ef 42af3333      	dc.w	17071,13107
6583  00f3               L7601:
6584  00f3 3400          	dc.b	"4",0
6585  00f5               L1601:
6586  00f5 3300          	dc.b	"3",0
6587  00f7               L3501:
6588  00f7 3200          	dc.b	"2",0
6589  00f9               L5401:
6590  00f9 3100          	dc.b	"1",0
6591  00fb               L7301:
6592  00fb 3000          	dc.b	"0",0
6593  00fd               L3301:
6594  00fd 4144433a2000  	dc.b	"ADC: ",0
6595  0103               L1301:
6596  0103 4f00          	dc.b	"O",0
6597  0105               L5201:
6598  0105 5a00          	dc.b	"Z",0
6599  0107               L1201:
6600  0107 464c3a00      	dc.b	"FL:",0
6601  010b               L7101:
6602  010b 4e00          	dc.b	"N",0
6603  010d               L3101:
6604  010d 4100          	dc.b	"A",0
6605  010f               L7001:
6606  010f 504f523a00    	dc.b	"POR:",0
6607  0114               L5001:
6608  0114 535441562054  	dc.b	"STAV TUNERU:",0
6609  0121               L177:
6610  0121 2d2d00        	dc.b	"--",0
6611  0124               L567:
6612  0124 2d3200        	dc.b	"-2",0
6613  0127               L757:
6614  0127 312d00        	dc.b	"1-",0
6615  012a               L157:
6616  012a 313200        	dc.b	"12",0
6617  012d               L537:
6618  012d 4e4143495441  	dc.b	"NACITAM FREKV. 2",0
6619  013e               L137:
6620  013e 554b4c414441  	dc.b	"UKLADAM FREKV. 2",0
6621  014f               L517:
6622  014f 4e4143495441  	dc.b	"NACITAM FREKV. 1",0
6623  0160               L117:
6624  0160 41200000      	dc.w	16672,0
6625  0164               L107:
6626  0164 554b4c414441  	dc.b	"UKLADAM FREKV. 1",0
6627  0175               L175:
6628  0175 53423a00      	dc.b	"SB:",0
6629  0179               L765:
6630  0179 533a00        	dc.b	"S:",0
6631  017c               L155:
6632  017c 53423a4e00    	dc.b	"SB:N",0
6633  0181               L745:
6634  0181 533a2d2d00    	dc.b	"S:--",0
6635  0186               L545:
6636  0186 535550455252  	dc.b	"SUPERRX",0
6637  018e               L345:
6638  018e 202020202020  	dc.b	"                ",0
6639  019f               L145:
6640  019f 4d487a00      	dc.b	"MHz",0
6641  01a3               L735:
6642  01a3 565354555020  	dc.b	"VSTUP FREKVENCE:",0
6643  01b4               L515:
6644  01b4 5a4d41434b4e  	dc.b	"ZMACKNI ENCODER",0
6645  01c4               L315:
6646  01c4 50524f205350  	dc.b	"PRO SPUSTENI",0
6647  01d1               L115:
6648  01d1 504f4d4f4349  	dc.b	"POMOCI TV TUNERU",0
6649  01e2               L705:
6650  01e2 5052494a494d  	dc.b	"PRIJIMAC",0
6651  01eb               L105:
6652  01eb 4e4143495441  	dc.b	"NACITAM PROGRAM",0
6653  01fb               L112:
6654  01fb 2000          	dc.b	" ",0
6655  01fd               L331:
6656  01fd 20202000      	dc.b	"   ",0
6657                     	xref.b	c_lreg
6658                     	xref.b	c_x
6678                     	xref	c_ladd
6679                     	xref	c_ludv
6680                     	xref	c_ftol
6681                     	xref	c_fmul
6682                     	xref	c_fcmp
6683                     	xref	c_fadd
6684                     	xref	c_uitof
6685                     	xref	c_fdiv
6686                     	xref	c_itof
6687                     	xref	c_uitolx
6688                     	xref	c_xymov
6689                     	xref	c_lcmp
6690                     	xref	c_ltor
6691                     	xref	c_lgsbc
6692                     	xref	c_lgadc
6693                     	xref	c_rtol
6694                     	xref	c_itolx
6695                     	xref	c_sdivx
6696                     	xref	c_smodx
6697                     	end
