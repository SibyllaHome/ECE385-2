// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x60; //make a pointer to access the PIO block
	volatile unsigned int *SWITCH_PIO = (unsigned int*)0x50;
	volatile unsigned int *KEY_PIO = (unsigned int*)0x40;
	*LED_PIO = 0; //clear all LEDs
	unsigned int accum = 0;
	int isPressed = 0; // isPressed = false "0"

	while ( (1+1) != 3) //infinite loop
	{
		if(*KEY_PIO == 0x2){accum = 0;}
		else if(isPressed == 0 && *KEY_PIO == 0x3){
			accum += *SWITCH_PIO;
			if(accum > 255){accum -= 256;}
			isPressed = 1;
		}
		if(*KEY_PIO != 0x3){isPressed = 0;}

		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= accum; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~accum; //clear LSB
	}
	return 1; //never gets here
}
