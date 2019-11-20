//io_handler.c
#include "io_handler.h"
#include <stdio.h>

void IO_init(void)
{
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
	// Reset OTG chip
	*otg_hpi_cs = 0;
	*otg_hpi_reset = 0;
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
}

void IO_write(alt_u8 Address, alt_u16 Data)
{
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	*otg_hpi_address = Address;
	*otg_hpi_cs = 0;
	*otg_hpi_w = 0;
	*otg_hpi_data = Data;
	*otg_hpi_cs = 1;
	*otg_hpi_w = 1;

//	*otg_hpi_cs = 0; // Enable chipselect, enable writing
//	*otg_hpi_address = Address;
////	*otg_hpi_r = 1;
//	*otg_hpi_w = 0;
////	*(otg_hpi_data + 1) |= 0x00FF;
//	 //write data to address
//	*otg_hpi_data = Data;
////	*(otg_hpi_data + 1) &= 0x0000;
//
//	*otg_hpi_w = 1;  // Disable writing
//	*otg_hpi_cs = 1; //turn chip off

}

alt_u16 IO_read(alt_u8 Address)
{
	alt_u16 temp;
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//

	*otg_hpi_address = Address;
	*otg_hpi_cs = 0;
	*otg_hpi_r = 0;
	temp = *otg_hpi_data;
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
//	printf("%x\n",temp);
	return temp;


//	*otg_hpi_cs = 0; // Enable chipselect, enable reading data
//    *otg_hpi_address = Address;
//	*otg_hpi_w = 1;
//	*otg_hpi_r = 0;
//
//    temp = *otg_hpi_data;
//
//	*otg_hpi_r = 1; // disable reading
//	*otg_hpi_cs = 1; //turn chip off
//
////	printf("%x\n",temp);
//	return temp;

}
