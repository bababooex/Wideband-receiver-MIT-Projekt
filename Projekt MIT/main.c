#include "stm8s.h"
#include "stm8s_gpio.h"
#include "milis.h"
#include "stm8s103_lcd_16x2.h"
#include "sw_i2c.h"
#include "delay.h"
#include "stdio.h"
#include "stdlib.h"
//EEPROM adresy pro sloty
#define EEPROM_ADDR_SLOT1_FLAG  0x4000
#define EEPROM_ADDR_SLOT1_FREC1 0x4001
#define EEPROM_ADDR_SLOT1_FREC2 0x4003

#define EEPROM_ADDR_SLOT2_FLAG  0x4004
#define EEPROM_ADDR_SLOT2_FREC1 0x4005
#define EEPROM_ADDR_SLOT2_FREC2 0x4007
//piny enkoderu
#define CLK_PIN GPIOD, GPIO_PIN_3
#define DT_PIN GPIOC, GPIO_PIN_4
#define SW_PIN GPIOE, GPIO_PIN_5
//tlacitka pro dalsi funkce
#define BTN1_PIN GPIOB, GPIO_PIN_0
#define BTN2_PIN GPIOB, GPIO_PIN_1
#define BTN3_PIN GPIOB, GPIO_PIN_2
#define BTN4_PIN GPIOB, GPIO_PIN_3
//r�zen� rel�
#define RELAY_PIN GPIOB, GPIO_PIN_4
//adresy pro I2C - pro cten� a z�pis
#define TDA6508A_I2C_WRITE 0xC0
#define TDA6508A_I2C_READ 0xC1
//piny klavesnice
#define KR_PO GPIOC  // rady
#define KR1_P GPIO_PIN_3
#define KR2_P GPIO_PIN_7
#define KR3_P GPIO_PIN_6
#define KR4_P GPIO_PIN_5

#define KS_PO GPIOE  // sloupce
#define KS1_P GPIO_PIN_2
#define KS2_P GPIO_PIN_1
#define KS3_P GPIO_PIN_3
//znaky klavesnice
const char keypad_chars[12] = {
    '#', '3', '6', '9', '0', '2', '5', '8', '*', '1', '4', '7'
};
//vsechny funkce
void Send_I2C_Buffer(uint8_t device_address, uint8_t *data, uint8_t length);
void Load_Animation(void);
void Encoder_Mode(void);
void GPIO_Init_Encoder(void);
void GPIO_Init_Keypad(void);
void GPIO_Init_Buttons(void);
void Frequency_Limits(void);
void Encoder_Read(void);
void Additional_Info(void);
void Print_Frequency(void);
void Update_Frequency(void);
void Radio_Frequency(void);
void Stand_By_Mode(void);
void Read_From_Tuner(void) ;
uint8_t Get_Keypad_Key(void);
void Handle_Keypad_Input(void);
void Control_Byte_Settings(void);
void Stored_In_Memory1(void);
void Stored_In_Memory2(void);
void Update_Memory_Indicator(void);
void LCD_Dec_Fix(void);
//vsechny promenne
uint8_t readstatus;
int encoder_done = 0;
int skip_verification;
int sb = 0;
int cnt;
uint8_t c;
uint8_t lastCLKState;
uint8_t Input_Clock = 0;
int8_t frec2;
uint16_t frec1;
float frec;
uint32_t freqkhz;
uint16_t freqB;
uint8_t bb;
uint8_t cb;
uint8_t buf1[4];
uint8_t buf2[2];
uint8_t l;
char new_frec1[4];
char new_frec2;
uint8_t input_stage;  
uint8_t input_position;
uint8_t input_error;
char key;
uint8_t status_byte;
int adc;
int isStored1 = 0;
int isStored2 = 0;
uint16_t addr_flag;
uint16_t addr_frec1;
uint16_t addr_frec2;
//hlavn� k�d - animace+cekani
void main(void) {
    CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV1);
    GPIO_Init(SW_PIN, GPIO_MODE_IN_PU_NO_IT);
    init_milis();
    Lcd_Begin();
    Lcd_Clear();
    Lcd_Set_Cursor(1, 1);
    Lcd_Print_String("NACITAM PROGRAM");
		Load_Animation();
    while (1) {
        Lcd_Clear();
        Lcd_Set_Cursor(1, 4);
        Lcd_Print_String("PRIJIMAC");
        Lcd_Set_Cursor(2, 1);
        Lcd_Print_String("POMOCI TV TUNERU");
        delay_ms(1500);
        Lcd_Clear();
        Lcd_Set_Cursor(1, 3);
        Lcd_Print_String("PRO SPUSTENI");
        Lcd_Set_Cursor(2, 1);
        Lcd_Print_String("ZMACKNI ENCODER");
        while (1) {
            if (GPIO_ReadInputPin(SW_PIN) == RESET) {
                delay_ms(200);
                Encoder_Mode();
                if (encoder_done) {
                    encoder_done = 0;
                    break;
                }
            }
        }
    }
}
//rezim po spusten� - uzivatel zm�cknul enkod�r
void Encoder_Mode(void) {
		GPIO_Init(RELAY_PIN, GPIO_MODE_OUT_PP_LOW_FAST);
    Lcd_Clear();
		GPIO_Init_Keypad();
    GPIO_Init_Encoder();
		GPIO_Init_Buttons();
    SW_I2C_init();
		Lcd_Set_Cursor(1, 1);
    Lcd_Print_String("VSTUP FREKVENCE:");
		Lcd_Set_Cursor(2, 11);
    Lcd_Print_String("MHz");
		skip_verification = 1; 
		Handle_Keypad_Input();
		Lcd_Set_Cursor(1, 1);
    Lcd_Print_String("                ");
		Lcd_Set_Cursor(1, 1);
    Lcd_Print_String("SUPERRX");
		Lcd_Set_Cursor(1, 13);
    Lcd_Print_String("S:--");
		Lcd_Set_Cursor(1, 9);
		Lcd_Print_String("SB:N");
		GPIO_WriteHigh(RELAY_PIN);
		//EEPROM aktualizace
		if (FLASH_ReadByte(EEPROM_ADDR_SLOT1_FLAG) == 1) {
    isStored1 = 1;
		}
		if (FLASH_ReadByte(EEPROM_ADDR_SLOT2_FLAG) == 1) {
    isStored2 = 1;
		}
		//
    while (1) {
        if (GPIO_ReadInputPin(SW_PIN) == RESET) {
            encoder_done = 1;
						Stand_By_Mode();
						GPIO_WriteLow(RELAY_PIN);
            delay_ms(200);
            break;
        }
				if (GPIO_ReadInputPin(BTN1_PIN) == RESET) {  
            Read_From_Tuner();
						delay_ms(2000);
						Lcd_Clear();
						Lcd_Set_Cursor(1, 1);
						Lcd_Print_String("SUPERRX");
						Lcd_Set_Cursor(2, 11);
						Lcd_Print_String("MHz");
						Lcd_Set_Cursor(1, 13);
						Lcd_Print_String("S:");
						Lcd_Set_Cursor(1, 9);
						Lcd_Print_String("SB:");
						Control_Byte_Settings();
						force_lcd_update = 1;
						Radio_Frequency();
						Print_Frequency();
						LCD_Dec_Fix();
				}
				if (GPIO_ReadInputPin(BTN2_PIN) == RESET) {  // Toggle Weak Signal Booster (WSB)
						sb++;
						Control_Byte_Settings();
						delay_ms(200);  // Debounce delay
				}
				if (GPIO_ReadInputPin(BTN3_PIN) == RESET) {
						Stored_In_Memory1();
						delay_ms(200);
				}
				if (GPIO_ReadInputPin(BTN4_PIN) == RESET) {
						Stored_In_Memory2();
						delay_ms(200);
				}
        Encoder_Read();
        Update_Frequency();
        Print_Frequency();
        Additional_Info();
        Frequency_Limits();
        Radio_Frequency();
				Handle_Keypad_Input();
				Update_Memory_Indicator();
    }
}
//ukl�d�n� do EEPROM
void EEPROM_Store_Slot(uint8_t slot, uint16_t f1, int8_t f2) {
    if (slot == 1) {
        addr_flag = EEPROM_ADDR_SLOT1_FLAG;
        addr_frec1 = EEPROM_ADDR_SLOT1_FREC1;
        addr_frec2 = EEPROM_ADDR_SLOT1_FREC2;
    } else {
        addr_flag = EEPROM_ADDR_SLOT2_FLAG;
        addr_frec1 = EEPROM_ADDR_SLOT2_FREC1;
        addr_frec2 = EEPROM_ADDR_SLOT2_FREC2;
    }
		//samotn� z�pis do pameti EEPROM
    FLASH_Unlock(FLASH_MEMTYPE_DATA);
    FLASH_ProgramByte(addr_frec1, f1 & 0xFF);
    FLASH_ProgramByte(addr_frec1 + 1, (f1 >> 8) & 0xFF);
    FLASH_ProgramByte(addr_frec2, f2);
    FLASH_ProgramByte(addr_flag, 1);
    FLASH_Lock(FLASH_MEMTYPE_DATA);
		//
}
//nac�t�n� z EEPROM
uint8_t EEPROM_Load_Slot(uint8_t slot, uint16_t* f1, int8_t* f2) {
    if (slot == 1) {
        addr_flag = EEPROM_ADDR_SLOT1_FLAG;
        addr_frec1 = EEPROM_ADDR_SLOT1_FREC1;
        addr_frec2 = EEPROM_ADDR_SLOT1_FREC2;
    } else {
        addr_flag = EEPROM_ADDR_SLOT2_FLAG;
        addr_frec1 = EEPROM_ADDR_SLOT2_FREC1;
        addr_frec2 = EEPROM_ADDR_SLOT2_FREC2;
    }
    if (FLASH_ReadByte(addr_flag) != 1) {
        return 0; 
    }
		//cten� konkretn�ch  byt� z pameti
    *f1 = FLASH_ReadByte(addr_frec1) | (FLASH_ReadByte(addr_frec1 + 1) << 8);
    *f2 = FLASH_ReadByte(addr_frec2);
    return 1;
}
//funkce pro ukl�d�n� do slot� v pameti - slot 1 a 2
void Stored_In_Memory1() {
    if (isStored1==0) {
        isStored1 = 1;
				EEPROM_Store_Slot(1, frec1, frec2);
				Lcd_Set_Cursor(1, 1);
				Lcd_Print_String("UKLADAM FREKV. 1");
				delay_ms(1500);
				Lcd_Set_Cursor(1, 8);
				Lcd_Print_String(" ");
				Lcd_Set_Cursor(1, 1);
				Lcd_Print_String("SUPERRX");
				Lcd_Set_Cursor(1, 13);
				Lcd_Print_String("S:");
				Lcd_Set_Cursor(1, 9);
				Lcd_Print_String("SB:");
				Control_Byte_Settings();
				Update_Memory_Indicator();
    } else {
				EEPROM_Load_Slot(1, &frec1, &frec2);
				frec = frec1 + frec2 / 10.0f;//korekce frekvence 
        isStored1 = 0; 
				//vymaz�n� EEPROMU po nacten�
				FLASH_Unlock(FLASH_MEMTYPE_DATA);
				FLASH_EraseByte(EEPROM_ADDR_SLOT1_FLAG);
				FLASH_EraseByte(EEPROM_ADDR_SLOT1_FREC1);
				FLASH_EraseByte(EEPROM_ADDR_SLOT1_FREC1 + 1);
				FLASH_EraseByte(EEPROM_ADDR_SLOT1_FREC2);
				FLASH_Lock(FLASH_MEMTYPE_DATA);
				//
				Lcd_Set_Cursor(1, 1);
				Lcd_Print_String("NACITAM FREKV. 1");
				delay_ms(1500);
				Lcd_Set_Cursor(1, 8);
				Lcd_Print_String(" ");
				Lcd_Set_Cursor(1, 1);
				Lcd_Print_String("SUPERRX");
				Lcd_Set_Cursor(1, 13);
				Lcd_Print_String("S:");
				Lcd_Set_Cursor(1, 9);
				Lcd_Print_String("SB:");
				Control_Byte_Settings();
				Update_Memory_Indicator();
				force_lcd_update = 1;
				Radio_Frequency();
				Print_Frequency();
				LCD_Dec_Fix();
    }
}
void Stored_In_Memory2() {
    if (isStored2==0) {
        isStored2 = 1;
				EEPROM_Store_Slot(2, frec1, frec2);
				Lcd_Set_Cursor(1, 1);
				Lcd_Print_String("UKLADAM FREKV. 2");
				delay_ms(1500);
				Lcd_Set_Cursor(1, 8);
				Lcd_Print_String(" ");
				Lcd_Set_Cursor(1, 1);
				Lcd_Print_String("SUPERRX");
				Lcd_Set_Cursor(1, 13);
				Lcd_Print_String("S:");
				Lcd_Set_Cursor(1, 9);
				Lcd_Print_String("SB:");
				Control_Byte_Settings();
				Update_Memory_Indicator();
    } else {
				EEPROM_Load_Slot(2, &frec1, &frec2);
				frec = frec1 + frec2 / 10.0f;//korekce frekvence 
        isStored2 = 0; 
				//vymaz�n� EEPROMU po nacten�
				FLASH_Unlock(FLASH_MEMTYPE_DATA);
				FLASH_EraseByte(EEPROM_ADDR_SLOT2_FLAG);
				FLASH_EraseByte(EEPROM_ADDR_SLOT2_FREC1);
				FLASH_EraseByte(EEPROM_ADDR_SLOT2_FREC1 + 1);
				FLASH_EraseByte(EEPROM_ADDR_SLOT2_FREC2);
				FLASH_Lock(FLASH_MEMTYPE_DATA);
				//
				Lcd_Set_Cursor(1, 1);
				Lcd_Print_String("NACITAM FREKV. 2");
				delay_ms(1500);
				Lcd_Set_Cursor(1, 8);
				Lcd_Print_String(" ");
				Lcd_Set_Cursor(1, 1);
				Lcd_Print_String("SUPERRX");
				Lcd_Set_Cursor(1, 13);
				Lcd_Print_String("S:");
				Lcd_Set_Cursor(1, 9);
				Lcd_Print_String("SB:");
				Control_Byte_Settings();
				Update_Memory_Indicator();
				force_lcd_update = 1;
				Radio_Frequency();
				Print_Frequency();
				LCD_Dec_Fix();
    }
}
//zobrazeni slot� pameti na lcd displayi
void Update_Memory_Indicator(void) {
		Lcd_Set_Cursor(1, 15);
    if (isStored1==1 && isStored2==1) {
        Lcd_Print_String("12");
    } else if (isStored1==1) {
        Lcd_Print_String("1-");
    } else if (isStored2==1) {
        Lcd_Print_String("-2");
    } else {
        Lcd_Print_String("--");
    }
}
//funkce pro cten� z tuneru pomoc� I2C sbernice a zobrazeni na displayi
void Read_From_Tuner(void) {
    SW_I2C_start();
		SW_I2C_write(TDA6508A_I2C_READ);
		if (SW_I2C_wait_ACK()) {
				SW_I2C_stop(); 
        return;
    }
    status_byte = SW_I2C_read(I2C_NACK);
    SW_I2C_stop();
		Lcd_Clear();
    Lcd_Set_Cursor(1, 3);
    Lcd_Print_String("STAV TUNERU:");
		Lcd_Set_Cursor(2, 1);
		//POWER ON RESET-indik�tor zapnut� tuneru a prvn�ho cten� dat s I2C
    Lcd_Print_String("POR:");
    if ((status_byte >> 7) & 1){
        Lcd_Print_String("A");  
    } else {
        Lcd_Print_String("N");
    }
    Lcd_Set_Cursor(2, 7);
		//IN-LOCK FLAG-indikuje �spe�n� naladen� tuneru
    Lcd_Print_String("FL:");
    if ((status_byte >> 6) & 1){
        Lcd_Print_String("Z");
    } else {
        Lcd_Print_String("O");
    }
		Lcd_Set_Cursor(2, 12);
		//stav ADC tuneru (nevyu�ito)
    Lcd_Print_String("ADC: ");
		adc = status_byte & 7;
		Lcd_Set_Cursor(2, 16);
    if (adc == 0){
			Lcd_Print_String("0");
		}
		else if (adc == 1){
			Lcd_Print_String("1");
		}
		else if (adc == 2){
			Lcd_Print_String("2");
		}
		else if (adc == 3){
			Lcd_Print_String("3");
		}
		else if (adc == 4){
			Lcd_Print_String("4");
		}
}
//funkce pro animaci
void Load_Animation(void) {
    for (cnt = 0; cnt < 17; cnt++) {
        Lcd_Set_Cursor(2, cnt);
        Lcd_Print_Char(0xFF);
        delay_ms(100);
    }
    delay_ms(100);
}

//funkce pro inicializaci enkod�ru
void GPIO_Init_Encoder(void) {
    GPIO_Init(CLK_PIN, GPIO_MODE_IN_PU_NO_IT);
    GPIO_Init(DT_PIN, GPIO_MODE_IN_PU_NO_IT);
}
//funkce pro inicializaci kl�vesnice
void GPIO_Init_Keypad(void) {
		GPIO_Init(KR_PO, KR1_P | KR2_P | KR3_P | KR4_P, GPIO_MODE_IN_PU_NO_IT);
    GPIO_Init(KS_PO, KS1_P | KS2_P | KS3_P, GPIO_MODE_OUT_OD_HIZ_FAST);
}
//funkce pro inicializaci tlacitek
void GPIO_Init_Buttons(void){
	GPIO_Init(BTN1_PIN, GPIO_MODE_IN_PU_NO_IT);
	GPIO_Init(BTN2_PIN, GPIO_MODE_IN_PU_NO_IT);
	GPIO_Init(BTN3_PIN, GPIO_MODE_IN_PU_NO_IT);
	GPIO_Init(BTN4_PIN, GPIO_MODE_IN_PU_NO_IT);
}
//poznamka - tyto funkce slouzi k predejit� neocek�van�ho chov�n� v k�du

//funkce pro ovl�d�n� vnitrn�ho zesilovace v tuneru
void Control_Byte_Settings(void) {
		if (sb>1){
			sb=0;
		}
		Lcd_Set_Cursor(1, 12);
		if (sb == 1) {
				Lcd_Print_String("A");  
		} else {
				Lcd_Print_String("N");
		}
		cb = 0b11000000 | ((sb & 1) << 0);
    buf2[0] = cb;       
    buf2[1] = bb;  
    Send_I2C_Buffer(TDA6508A_I2C_WRITE, buf2, 2);
}
//funkce pro zji���tov�n� stavu enkod�ru
void Encoder_Read(void) {
    static uint8_t lastState = 0;
    uint8_t currentState = 0;
    _delay_us(150); 
    if (GPIO_ReadInputPin(CLK_PIN)) currentState |= 0x01;
    if (GPIO_ReadInputPin(DT_PIN)) currentState |= 0x02;
    if ((lastState == 0x00 && currentState == 0x01) ||
        (lastState == 0x01 && currentState == 0x03) ||
        (lastState == 0x03 && currentState == 0x02) ||
        (lastState == 0x02 && currentState == 0x00)) {
        frec2 += 1; 
    } else if ((lastState == 0x00 && currentState == 0x02) ||
               (lastState == 0x02 && currentState == 0x03) ||
               (lastState == 0x03 && currentState == 0x01) ||
               (lastState == 0x01 && currentState == 0x00)) {
        frec2 -= 1;
    }
    lastState = currentState;
}
//funkce pro opravu zobrazov�n� na displayi (docela neefektivn�, ale tak� re�en�)
void LCD_Dec_Fix (void) {
		if (frec2 == 0) {
		Lcd_Set_Cursor(2, 9);
		Lcd_Print_Char('0');
		}
		else if (frec2 == 1) {
		Lcd_Set_Cursor(2, 9);
		Lcd_Print_Char('1');
		}
		else if (frec2 == 2) {
		Lcd_Set_Cursor(2, 9);
		Lcd_Print_Char('2');
		}
		else if (frec2 == 3) {
		Lcd_Set_Cursor(2, 9);
		Lcd_Print_Char('3');
		}
		else if (frec2 == 4) {
		Lcd_Set_Cursor(2, 9);
		Lcd_Print_Char('4');
		}
		else if (frec2 == 5) {
		Lcd_Set_Cursor(2, 9);
		Lcd_Print_Char('5');
		}
		else if (frec2 == 6) {
		Lcd_Set_Cursor(2, 9);
		Lcd_Print_Char('6');
		}
		else if (frec2 == 7) {
		Lcd_Set_Cursor(2, 9);
		Lcd_Print_Char('7');
		}
		else if (frec2 == 8) {
		Lcd_Set_Cursor(2, 9);
		Lcd_Print_Char('8');
		}
		else if (frec2 == 9) {
		Lcd_Set_Cursor(2, 9);
		Lcd_Print_Char('9');
		}
}
//funkce pro zobrazen� postrann�ch informac� o prij�man�m p�smu na LCD displayi
void Additional_Info(void){
				if (frec >=87.6 && frec<= 108.0) {
								Lcd_Set_Cursor(2,3);
								Lcd_Print_String(" ");
                Lcd_Set_Cursor(2,1);
                Lcd_Print_String("FM");
        } 
				else if (frec >108.0 && frec <=136.0) {   
                Lcd_Set_Cursor(2,1);
                Lcd_Print_String("AIR");  
        }
				else if (frec >=137.0 && frec <=138.0) {   
                Lcd_Set_Cursor(2,1);
                Lcd_Print_String("SAT");  
        }
				else if (frec >=174.0 && frec <=239.0){
								Lcd_Set_Cursor(2,1);
                Lcd_Print_String("DAB"); 
				}
				else if (frec>239.0 && frec<380.0){
								Lcd_Set_Cursor(2,1);
								Lcd_Print_String("MIL");
				}
				else if (frec >=433.0 && frec <434.9 || frec >=855.0 && frec <=868.0) {  
                Lcd_Set_Cursor(2,1);
                Lcd_Print_String("ISM");  
        }
				else if (frec>=144.0 && frec<=148.0){
								Lcd_Set_Cursor(2,3);
								Lcd_Print_String(" ");
								Lcd_Set_Cursor(2,1);
								Lcd_Print_String("2M");
				}
				else if (frec>=160.0 && frec<=174.0){
								Lcd_Set_Cursor(2,1);
								Lcd_Print_String("IZS");
				}
				else if (frec>=430.0 && frec<=440.0){
								Lcd_Set_Cursor(2,1);
								Lcd_Print_String("3/4");
				}
				else if (frec>=400.0 && frec<=406.0){
								Lcd_Set_Cursor(2,1);
								Lcd_Print_String("WBL");
				}
				else if (frec>=410.0 && frec<430.0 || frec>=380.0 && frec<400.0){
								Lcd_Set_Cursor(2,1);
								Lcd_Print_String("TET");
				}
				else if (frec >=446.0 && frec <=446.2) {  
                Lcd_Set_Cursor(2,1);
                Lcd_Print_String("PMR");  
        }
				else if (frec>=50.0 && frec<=54.0){
								Lcd_Set_Cursor(2,3);
								Lcd_Print_String(" ");
								Lcd_Set_Cursor(2,1);
								Lcd_Print_String("6M");
				}
				else if (frec>=67.6 && frec<=71.3){
								Lcd_Set_Cursor(2,1);
								Lcd_Print_String("HLS");
				}
				else if (frec>71.3 && frec<=72.8){
								Lcd_Set_Cursor(2,3);
								Lcd_Print_String(" ");
								Lcd_Set_Cursor(2,1);
								Lcd_Print_String("4M");
				}
        else {  
								Lcd_Set_Cursor(2,0);
								Lcd_Print_String("   ");
				}
}
//funkce pro pos�l�n� dat pomoc� I2C sbernice do tuneru
void Send_I2C_Buffer(uint8_t device_address, uint8_t *data, uint8_t length) {
    SW_I2C_start();
    SW_I2C_write(device_address);
    if (SW_I2C_wait_ACK()) {
        SW_I2C_stop(); 
        return;
    }
    for (l = 0; l < length; l++) {  
        SW_I2C_write(data[l]);  
        if (SW_I2C_wait_ACK()) {
            SW_I2C_stop();  
            return;
        }
    }
    SW_I2C_stop();  
}
//funkce, kter� se star� o spr�vn� nastaven� p�sem a tak� o korekci frekvence na 37.7MHz - pro demodul�tor
void Radio_Frequency(void) {
    freqkhz = (uint32_t)(frec * 1000);
    freqB = (freqkhz / 50) + 754;// z v�poctu: Frekvence laden� v kHz/krok laden� + IF frekvence v kHz, napr. 38kHz/krok laden�
    // 3 mo�n� p�sma - VHF L, VHF H, UHF
    if (freqkhz < 152000) {
        bb = 0b00000001;
    } else if (freqkhz < 437000) {
        bb = 0b00000010;
    } else {
        bb = 0b00001000;
    }
    cb = 0b11000000 | ((sb & 1) << 0); 
		// data jsou pos�l�na podle datasheetu
    buf1[0] = (freqB >> 8) & 0x7F;  
    buf1[1] = freqB & 0xFF;         
    buf1[2] = cb;                   
    buf1[3] = bb;                 

    Send_I2C_Buffer(TDA6508A_I2C_WRITE, buf1, 4);
}
//funkce pro re�im n�zk� spotreby tuneru, tuner nen� zapnut� - tzv. standby
void Stand_By_Mode(void){
	buf2[0] = 0b11001000;  //cb             
	buf2[1] = 0b00000011;  //bb 
	Send_I2C_Buffer(TDA6508A_I2C_WRITE, buf2, 2);
}
//funkce pro zobrazen� frekvence na LCD displayi
void Print_Frequency(void) {
    if (frec >= 100.0)  {
        Lcd_Print_Int_At1(2, 5, frec1);
			}
		else if (frec < 100.0) {
				Lcd_Set_Cursor(2, 5);
				Lcd_Print_String(" ");
        Lcd_Print_Int_At1(2, 6, frec1);
			}
		Lcd_Set_Cursor(2, 8);
		Lcd_Print_String(".");
		Lcd_Print_Int_At2(2, 9, frec2);
}
//funkce pro aktualizaci frekvence pri z�sahu u�ivatele pomoc� enkod�ru nebo kl�vesnice
void Update_Frequency(void) {
    frec = frec1 + (frec2 / 10.0);
    if (frec2 > 9) {
        frec1++;
        frec2 = 0;
    }
    if (frec2 < 0) {
        frec1--;
        frec2 = 9;
    }
}
//funkce pro limitaci u�ivatele kvuli presahu frekvencn�ho limitu tuneru
void Frequency_Limits(void) {
    if (frec > 870.0) {
        Lcd_Set_Cursor(2, 15);
        Lcd_Print_String("L");
        delay_ms(1500);
        frec2 = 0;
        frec1 = 870;
        frec = 870.0;
				Radio_Frequency();
        Print_Frequency();
    } 
    if (frec < 45.0) {
        Lcd_Set_Cursor(2, 15);
        Lcd_Print_String("L");
        delay_ms(1500);
        frec2 = 0;
        frec1 = 45;
        frec = 45.0;
				Radio_Frequency();
        Print_Frequency();
    } else {
        Lcd_Set_Cursor(2, 15);
        Lcd_Print_String(" ");
    }
}
//funkce pro z�sk�n� znaku z maticov� kl�vesnice
uint8_t Get_Keypad_Key(void) {
    uint8_t col, row_state;
    GPIO_WriteHigh(KS_PO, KS1_P | KS2_P | KS3_P);
    for (col = 0; col < 3; col++) {
        GPIO_WriteHigh(KS_PO, KS1_P | KS2_P | KS3_P);
        switch (col) {
            case 0: GPIO_WriteLow(KS_PO, KS1_P); break;
            case 1: GPIO_WriteLow(KS_PO, KS2_P); break;
            case 2: GPIO_WriteLow(KS_PO, KS3_P); break;
        }
        delay_ms(12); 
        row_state = GPIO_ReadInputData(KR_PO) & 0b11101000;
        if (row_state != 0b11101000) {
            switch (row_state) {
                case 0b11100000: return (col * 4) + 0;
                case 0b11001000: return (col * 4) + 1;
                case 0b10101000: return (col * 4) + 2;
                case 0b01101000: return (col * 4) + 3;
            }
        }
    }
    return 255;
}
//funkce, kter� se star� o zad�v�n� frekvence u�ivatelem a tak� hl�d� limit frekvencn�ho rozsahu tuneru
void Handle_Keypad_Input(void) {
readstatus = Get_Keypad_Key();
key = keypad_chars[readstatus];
			if (key == '*' | skip_verification==1) {
            do {
                input_error = 0;
								Lcd_Set_Cursor(2, 16);
								Lcd_Print_String("K");
								Lcd_Print_String("     ");
                Lcd_Set_Cursor(2, 5);
                Lcd_Print_String("___._ MHz");
                memset(new_frec1, 0, sizeof(new_frec1));
                new_frec2 = '0';
                input_stage = 1;  
                input_position = 5;
                Lcd_Set_Cursor(2, 8);
                Lcd_Print_Char('.');
                while (1) {
                    uint8_t key_read = Get_Keypad_Key();
                    if (key_read < 12) {
                        char key_input = keypad_chars[key_read];
                        if (key_input >= '0' && key_input <= '9') {
                            if (input_stage == 1 && strlen(new_frec1) < 3) {
                                new_frec1[strlen(new_frec1)] = key_input;
                                Lcd_Set_Cursor(2, input_position);
                                Lcd_Print_Char(key_input);
                                input_position++; 
                                if (strlen(new_frec1) == 3) {
                                    input_stage = 2;
                                    input_position = 9;
                                }
                            } 
                            else if (input_stage == 2) {
                                new_frec2 = key_input;
                                Lcd_Set_Cursor(2, input_position);
                                Lcd_Print_Char(key_input);
                            }
                        } 
                        else if (key_input == '#') {
                            frec1 = atoi(new_frec1);
                            frec2 = new_frec2 - '0';
                            if (frec1 > 870) {
                                input_error = 1;  
                                break;  
                            }
														if (frec1 < 45) {
                                input_error = 1;
                                break; 
                            }
                            frec = frec1 + (frec2 / 10.0);
                            force_lcd_update = 1;
														Lcd_Set_Cursor(2, 16);
														Lcd_Print_String(" ");
														Lcd_Set_Cursor(2, 5);
														Lcd_Print_String("     ");
                            Radio_Frequency();
                            Print_Frequency();
														LCD_Dec_Fix();
														skip_verification = 0;
                            return; 
                        }
                    }
                    delay_ms(100);
                }
                if (input_error) {
                    Lcd_Set_Cursor(2, 5);
                    Lcd_Print_String("CHYBA!");
                    delay_ms(2000);
                }
            } while (input_error);
				} 
		else{
				return;
		}
}		


#ifdef USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param file: pointer to the source file name
  * @param line: assert_param error line source number
  * @retval : None
  */
void assert_failed(u8* file, u32 line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif



