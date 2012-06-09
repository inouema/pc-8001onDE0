/* 
 * "Small Hello World" example. 
 * 
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example 
 * designs. It requires a STDOUT  device in your system's hardware. 
 *
 * The purpose of this example is to demonstrate the smallest possible Hello 
 * World application, using the Nios II HAL library.  The memory footprint
 * of this hosted application is ~332 bytes by default using the standard 
 * reference design.  For a more fully featured Hello World application
 * example, see the example titled "Hello World".
 *
 * The memory footprint of this example has been reduced by making the
 * following changes to the normal "Hello World" example.
 * Check in the Nios II Software Developers Manual for a more complete 
 * description.
 * 
 * In the SW Application project (small_hello_world):
 *
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 * In System Library project (small_hello_world_syslib):
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 *    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
 *      This removes software exception handling, which means that you cannot 
 *      run code compiled for Nios II cpu with a hardware multiplier on a core 
 *      without a the multiply unit. Check the Nios II Software Developers 
 *      Manual for more details.
 *
 *  - In the System Library page:
 *    - Set Periodic system timer and Timestamp timer to none
 *      This prevents the automatic inclusion of the timer driver.
 *
 *    - Set Max file descriptors to 4
 *      This reduces the size of the file handle pool.
 *
 *    - Check Main function does not exit
 *    - Uncheck Clean exit (flush buffers)
 *      This removes the unneeded call to exit when main returns, since it
 *      won't.
 *
 *    - Check Don't use C++
 *      This builds without the C++ support code.
 *
 *    - Check Small C library
 *      This uses a reduced functionality C library, which lacks  
 *      support for buffering, file IO, floating point and getch(), etc. 
 *      Check the Nios II Software Developers Manual for a complete list.
 *
 *    - Check Reduced device drivers
 *      This uses reduced functionality drivers if they're available. For the
 *      standard design this means you get polled UART and JTAG UART drivers,
 *      no support for the LCD driver and you lose the ability to program 
 *      CFI compliant flash devices.
 *
 *    - Check Access device drivers directly
 *      This bypasses the device file system to access device drivers directly.
 *      This eliminates the space required for the device file system services.
 *      It also provides a HAL version of libc services that access the drivers
 *      directly, further reducing space. Only a limited number of libc
 *      functions are available in this configuration.
 *
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */

#include "sys/alt_stdio.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"


/* PC-8001 Test Program */
/*                      */
/* cload"SDLOAD"        */
/* 10 PRINT"PC-8001"    */
static unsigned char rcv;
static unsigned char prg[] = {
	0xd3,
	0xd3,
	0xd3,
	0xd3,
	0xd3,
	0xd3,
	0xd3,
	0xd3,
	0xd3,
	0xd3,
	0x53,
	0x44,
	0x4c,
	0x4f,
	0x41,
	0x44,
	0x30,
	0x80,
	0x0a,
	0x00,
	0x91,
	0x22,
	0x50,
	0x43,
	0x2d,
	0x38,
	0x30,
	0x30,
	0x31,
	0x22,
	0x00,
	0x00,
	0x00,
	0x00,
	0x00,
	0x00,
	0x00,
	0x00,
	0x00,
	0x00,
	0x00,
	0x00
};

/**************************************************************/
/*** Macro's **************************************************/
/**************************************************************/
#define P_CMT_LOAD  (0x01)
#define P_CMT_TxRDY (0x02)
#define P_CMT_SAVE  (0x04)
#define P_CMT_MOTOR (0x10)


#define P_CMT_GPIO_RD()     (IORD_ALTERA_AVALON_PIO_DATA(CMT_GPIO_IN_BASE))
#define P_CMT_GPIO_WR(a)    (IOWR_ALTERA_AVALON_PIO_DATA(CMT_GPIO_OUT_BASE, a))
#define P_CMT_DOUT_WR(a)    (IOWR_ALTERA_AVALON_PIO_DATA(CMT_DOUT_BASE, a))
#define P_CMT_MCU_WR_ASSERT (0x01)
#define P_CMT_MCU_WR_NEGATE (0x00)
#define P_CMT_MCU_RD_ASSERT (0x02)
#define P_CMT_MCU_RD_NEGATE (0x00)


int main()
{

	int i=0;
	int j=0;
	alt_putstr("Hello from Nios II!\n");

	/* Event loop never exits. */
	while (1)
	{
		if( (P_CMT_GPIO_RD() & P_CMT_LOAD) && (P_CMT_GPIO_RD() & P_CMT_MOTOR) )
		{
			alt_putstr("Tx start.\n");
			for(i=0; i<625000; i++); // dummy wait 2.5s
			for(i=0; i<(sizeof(prg)/sizeof(prg[0])); i++)
			{
				P_CMT_GPIO_WR(P_CMT_MCU_WR_ASSERT);
				P_CMT_DOUT_WR(prg[i]);
				P_CMT_GPIO_WR(P_CMT_MCU_WR_NEGATE);
				for(j=0; j<10000; j++);
				alt_printf("Tx data %x\n",prg[i]);
				while( P_CMT_GPIO_RD() & P_CMT_TxRDY ); /* wait for send ok */
			}
			for(i=0; i<325000; i++); // dummy wait 1.3s
			alt_putstr("Tx end.\n");
		}
		if( (P_CMT_GPIO_RD() & P_CMT_SAVE) && (P_CMT_GPIO_RD() & P_CMT_MOTOR) )
		{
			alt_putstr("Rx start.\n");
			while( (IORD_ALTERA_AVALON_PIO_DATA(CMT_GPIO_IN_BASE) & 0x08 )); /* wait for receive ok */
			IOWR_ALTERA_AVALON_PIO_DATA(CMT_GPIO_OUT_BASE, P_CMT_MCU_RD_ASSERT);
			rcv = IORD_ALTERA_AVALON_PIO_DATA(CMT_DIN_BASE);
			IOWR_ALTERA_AVALON_PIO_DATA(CMT_GPIO_OUT_BASE, P_CMT_MCU_RD_NEGATE);
			for(i=0; i<10000; i++); // test wait.
			alt_printf("Rx data %x\n",rcv);
		}
	}; // while

  return 0;
}
