/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'nios2' in SOPC Builder design 'pc8001_sub_system'
 * SOPC Builder design path: D:/home/inouema/work/git/pc-8001onDE0/project/rtl/sub_system/pc8001_sub_system.sopcinfo
 *
 * Generated: Sun Jun 10 12:44:01 JST 2012
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x820
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x0
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1a
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x2000020
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x1a
#define ALT_CPU_NAME "nios2"
#define ALT_CPU_RESET_ADDR 0x2000000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x820
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x0
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x1a
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x2000020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x1a
#define NIOS2_RESET_ADDR 0x2000000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_EPCS_FLASH_CONTROLLER
#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID
#define __ALTERA_AVALON_TIMER
#define __ALTERA_NIOS2
#define __ALTPLL
#define __AVALONIF_MMC


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "CYCLONEIII"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x20
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x20
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x20
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "pc8001_sub_system"


/*
 * cmt_din configuration
 *
 */

#define ALT_MODULE_CLASS_cmt_din altera_avalon_pio
#define CMT_DIN_BASE 0x40
#define CMT_DIN_BIT_CLEARING_EDGE_REGISTER 0
#define CMT_DIN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define CMT_DIN_CAPTURE 0
#define CMT_DIN_DATA_WIDTH 8
#define CMT_DIN_DO_TEST_BENCH_WIRING 0
#define CMT_DIN_DRIVEN_SIM_VALUE 0x0
#define CMT_DIN_EDGE_TYPE "NONE"
#define CMT_DIN_FREQ 10000000u
#define CMT_DIN_HAS_IN 1
#define CMT_DIN_HAS_OUT 0
#define CMT_DIN_HAS_TRI 0
#define CMT_DIN_IRQ -1
#define CMT_DIN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define CMT_DIN_IRQ_TYPE "NONE"
#define CMT_DIN_NAME "/dev/cmt_din"
#define CMT_DIN_RESET_VALUE 0x0
#define CMT_DIN_SPAN 16
#define CMT_DIN_TYPE "altera_avalon_pio"


/*
 * cmt_dout configuration
 *
 */

#define ALT_MODULE_CLASS_cmt_dout altera_avalon_pio
#define CMT_DOUT_BASE 0x30
#define CMT_DOUT_BIT_CLEARING_EDGE_REGISTER 0
#define CMT_DOUT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define CMT_DOUT_CAPTURE 0
#define CMT_DOUT_DATA_WIDTH 8
#define CMT_DOUT_DO_TEST_BENCH_WIRING 0
#define CMT_DOUT_DRIVEN_SIM_VALUE 0x0
#define CMT_DOUT_EDGE_TYPE "NONE"
#define CMT_DOUT_FREQ 10000000u
#define CMT_DOUT_HAS_IN 0
#define CMT_DOUT_HAS_OUT 1
#define CMT_DOUT_HAS_TRI 0
#define CMT_DOUT_IRQ -1
#define CMT_DOUT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define CMT_DOUT_IRQ_TYPE "NONE"
#define CMT_DOUT_NAME "/dev/cmt_dout"
#define CMT_DOUT_RESET_VALUE 0x0
#define CMT_DOUT_SPAN 16
#define CMT_DOUT_TYPE "altera_avalon_pio"


/*
 * cmt_gpio_in configuration
 *
 */

#define ALT_MODULE_CLASS_cmt_gpio_in altera_avalon_pio
#define CMT_GPIO_IN_BASE 0x60
#define CMT_GPIO_IN_BIT_CLEARING_EDGE_REGISTER 0
#define CMT_GPIO_IN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define CMT_GPIO_IN_CAPTURE 0
#define CMT_GPIO_IN_DATA_WIDTH 8
#define CMT_GPIO_IN_DO_TEST_BENCH_WIRING 0
#define CMT_GPIO_IN_DRIVEN_SIM_VALUE 0x0
#define CMT_GPIO_IN_EDGE_TYPE "NONE"
#define CMT_GPIO_IN_FREQ 10000000u
#define CMT_GPIO_IN_HAS_IN 1
#define CMT_GPIO_IN_HAS_OUT 0
#define CMT_GPIO_IN_HAS_TRI 0
#define CMT_GPIO_IN_IRQ -1
#define CMT_GPIO_IN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define CMT_GPIO_IN_IRQ_TYPE "NONE"
#define CMT_GPIO_IN_NAME "/dev/cmt_gpio_in"
#define CMT_GPIO_IN_RESET_VALUE 0x0
#define CMT_GPIO_IN_SPAN 16
#define CMT_GPIO_IN_TYPE "altera_avalon_pio"


/*
 * cmt_gpio_out configuration
 *
 */

#define ALT_MODULE_CLASS_cmt_gpio_out altera_avalon_pio
#define CMT_GPIO_OUT_BASE 0x50
#define CMT_GPIO_OUT_BIT_CLEARING_EDGE_REGISTER 0
#define CMT_GPIO_OUT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define CMT_GPIO_OUT_CAPTURE 0
#define CMT_GPIO_OUT_DATA_WIDTH 8
#define CMT_GPIO_OUT_DO_TEST_BENCH_WIRING 0
#define CMT_GPIO_OUT_DRIVEN_SIM_VALUE 0x0
#define CMT_GPIO_OUT_EDGE_TYPE "NONE"
#define CMT_GPIO_OUT_FREQ 10000000u
#define CMT_GPIO_OUT_HAS_IN 0
#define CMT_GPIO_OUT_HAS_OUT 1
#define CMT_GPIO_OUT_HAS_TRI 0
#define CMT_GPIO_OUT_IRQ -1
#define CMT_GPIO_OUT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define CMT_GPIO_OUT_IRQ_TYPE "NONE"
#define CMT_GPIO_OUT_NAME "/dev/cmt_gpio_out"
#define CMT_GPIO_OUT_RESET_VALUE 0x0
#define CMT_GPIO_OUT_SPAN 16
#define CMT_GPIO_OUT_TYPE "altera_avalon_pio"


/*
 * epcs_flash_controller configuration
 *
 */

#define ALT_MODULE_CLASS_epcs_flash_controller altera_avalon_epcs_flash_controller
#define EPCS_FLASH_CONTROLLER_BASE 0x1800
#define EPCS_FLASH_CONTROLLER_IRQ 3
#define EPCS_FLASH_CONTROLLER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define EPCS_FLASH_CONTROLLER_NAME "/dev/epcs_flash_controller"
#define EPCS_FLASH_CONTROLLER_REGISTER_OFFSET 1024
#define EPCS_FLASH_CONTROLLER_SPAN 2048
#define EPCS_FLASH_CONTROLLER_TYPE "altera_avalon_epcs_flash_controller"


/*
 * gpio0 configuration
 *
 */

#define ALT_MODULE_CLASS_gpio0 altera_avalon_pio
#define GPIO0_BASE 0x0
#define GPIO0_BIT_CLEARING_EDGE_REGISTER 0
#define GPIO0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define GPIO0_CAPTURE 0
#define GPIO0_DATA_WIDTH 8
#define GPIO0_DO_TEST_BENCH_WIRING 0
#define GPIO0_DRIVEN_SIM_VALUE 0x0
#define GPIO0_EDGE_TYPE "NONE"
#define GPIO0_FREQ 10000000u
#define GPIO0_HAS_IN 0
#define GPIO0_HAS_OUT 1
#define GPIO0_HAS_TRI 0
#define GPIO0_IRQ -1
#define GPIO0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define GPIO0_IRQ_TYPE "NONE"
#define GPIO0_NAME "/dev/gpio0"
#define GPIO0_RESET_VALUE 0x0
#define GPIO0_SPAN 16
#define GPIO0_TYPE "altera_avalon_pio"


/*
 * gpio1 configuration
 *
 */

#define ALT_MODULE_CLASS_gpio1 altera_avalon_pio
#define GPIO1_BASE 0x10
#define GPIO1_BIT_CLEARING_EDGE_REGISTER 0
#define GPIO1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define GPIO1_CAPTURE 0
#define GPIO1_DATA_WIDTH 8
#define GPIO1_DO_TEST_BENCH_WIRING 0
#define GPIO1_DRIVEN_SIM_VALUE 0x0
#define GPIO1_EDGE_TYPE "NONE"
#define GPIO1_FREQ 10000000u
#define GPIO1_HAS_IN 1
#define GPIO1_HAS_OUT 0
#define GPIO1_HAS_TRI 0
#define GPIO1_IRQ -1
#define GPIO1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define GPIO1_IRQ_TYPE "NONE"
#define GPIO1_NAME "/dev/gpio1"
#define GPIO1_RESET_VALUE 0x0
#define GPIO1_SPAN 16
#define GPIO1_TYPE "altera_avalon_pio"


/*
 * hal configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK TIMER_0
#define ALT_TIMESTAMP_CLK none


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x20
#define JTAG_UART_IRQ 0
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * mmc_spi configuration
 *
 */

#define ALT_MODULE_CLASS_mmc_spi avalonif_mmc
#define MMC_SPI_BASE 0x70
#define MMC_SPI_IRQ 2
#define MMC_SPI_IRQ_INTERRUPT_CONTROLLER_ID 0
#define MMC_SPI_NAME "/dev/mmc_spi"
#define MMC_SPI_SPAN 16
#define MMC_SPI_TYPE "avalonif_mmc"


/*
 * sdram configuration
 *
 */

#define ALT_MODULE_CLASS_sdram altera_avalon_new_sdram_controller
#define SDRAM_BASE 0x2000000
#define SDRAM_CAS_LATENCY 3
#define SDRAM_CONTENTS_INFO ""
#define SDRAM_INIT_NOP_DELAY 0.0
#define SDRAM_INIT_REFRESH_COMMANDS 2
#define SDRAM_IRQ -1
#define SDRAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_IS_INITIALIZED 1
#define SDRAM_NAME "/dev/sdram"
#define SDRAM_POWERUP_DELAY 100.0
#define SDRAM_REFRESH_PERIOD 15.625
#define SDRAM_REGISTER_DATA_IN 1
#define SDRAM_SDRAM_ADDR_WIDTH 0x16
#define SDRAM_SDRAM_BANK_WIDTH 2
#define SDRAM_SDRAM_COL_WIDTH 8
#define SDRAM_SDRAM_DATA_WIDTH 16
#define SDRAM_SDRAM_NUM_BANKS 4
#define SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_SDRAM_ROW_WIDTH 12
#define SDRAM_SHARED_DATA 0
#define SDRAM_SIM_MODEL_BASE 1
#define SDRAM_SPAN 8388608
#define SDRAM_STARVATION_INDICATOR 0
#define SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_T_AC 5.5
#define SDRAM_T_MRD 3
#define SDRAM_T_RCD 20.0
#define SDRAM_T_RFC 70.0
#define SDRAM_T_RP 20.0
#define SDRAM_T_WR 14.0


/*
 * sub_system_pll configuration
 *
 */

#define ALT_MODULE_CLASS_sub_system_pll altpll
#define SUB_SYSTEM_PLL_BASE 0xa0
#define SUB_SYSTEM_PLL_IRQ -1
#define SUB_SYSTEM_PLL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SUB_SYSTEM_PLL_NAME "/dev/sub_system_pll"
#define SUB_SYSTEM_PLL_SPAN 16
#define SUB_SYSTEM_PLL_TYPE "altpll"


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid
#define SYSID_BASE 0x28
#define SYSID_ID 0u
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1339298534u
#define SYSID_TYPE "altera_avalon_sysid"


/*
 * timer_0 configuration
 *
 */

#define ALT_MODULE_CLASS_timer_0 altera_avalon_timer
#define TIMER_0_ALWAYS_RUN 0
#define TIMER_0_BASE 0x80
#define TIMER_0_COUNTER_SIZE 32
#define TIMER_0_FIXED_PERIOD 0
#define TIMER_0_FREQ 50000000u
#define TIMER_0_IRQ 1
#define TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TIMER_0_LOAD_VALUE 49999ull
#define TIMER_0_MULT 0.0010
#define TIMER_0_NAME "/dev/timer_0"
#define TIMER_0_PERIOD 1
#define TIMER_0_PERIOD_UNITS "ms"
#define TIMER_0_RESET_OUTPUT 0
#define TIMER_0_SNAPSHOT 1
#define TIMER_0_SPAN 32
#define TIMER_0_TICKS_PER_SEC 1000u
#define TIMER_0_TIMEOUT_PULSE_OUTPUT 0
#define TIMER_0_TYPE "altera_avalon_timer"

#endif /* __SYSTEM_H_ */
