// SPDX-License-Identifier: BSD-Source-Code

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <libbase/memtest.h>

#include <generated/csr.h>
#include <generated/mem.h>

#include "../command.h"
#include "../helpers.h"

/**
 * Command "mem_list"
 *
 * Memory list
 *
 */
static void mem_list_handler(int nb_params, char **params)
{
	printf("Available memory regions:\n");
	puts(MEM_REGIONS);
}

define_command(mem_list, mem_list_handler, "List available memory regions", MEM_CMDS);

/**
 * Command "mem_read"
 *
 * Memory read
 *
 */
static void mem_read_handler(int nb_params, char **params)
{
	char *c;
	unsigned int *addr;
	unsigned int length;

	if (nb_params < 1) {
		printf("mem_read <address> [length]");
		return;
	}
	addr = (unsigned int *)strtoul(params[0], &c, 0);
	if (*c != 0) {
		printf("Incorrect address");
		return;
	}
	if (nb_params == 1) {
		length = 4;
	} else {
		length = strtoul(params[1], &c, 0);
		if(*c != 0) {
			printf("\nIncorrect length");
			return;
		}
	}

	dump_bytes(addr, length, (unsigned long)addr);
}

define_command(mem_read, mem_read_handler, "Read address space", MEM_CMDS);

/**
 * Command "mem_write"
 *
 * Memory write
 *
 */
static void mem_write_handler(int nb_params, char **params)
{
	char *c;
	void *addr;
	unsigned int value;
	unsigned int count;
	unsigned int size;
	unsigned int i;

	if (nb_params < 2) {
		printf("mem_write <address> <value> [count] [size]");
		return;
	}

	size = 4;
	addr = (void *)strtoul(params[0], &c, 0);

	if (*c != 0) {
		printf("Incorrect address");
		return;
	}

	value = strtoul(params[1], &c, 0);
	if(*c != 0) {
		printf("Incorrect value");
		return;
	}

	if (nb_params == 2) {
		count = 1;
	} else {
		count = strtoul(params[2], &c, 0);
		if(*c != 0) {
			printf("Incorrect count");
			return;
		}
	}

	if (nb_params == 4)
		size = strtoul(params[3], &c, 0);

	for (i = 0; i < count; i++) {
		switch (size) {
		case 1:
			*(uint8_t *)addr = value;
			addr += 1;
			break;
		case 2:
			*(uint16_t *)addr = value;
			addr += 2;
			break;
		case 4:
			*(uint32_t *)addr = value;
			addr += 4;
			break;
		default:
			printf("Incorrect size");
			return;
		}
	}
}

define_command(mem_write, mem_write_handler, "Write address space", MEM_CMDS);

/**
 * Command "transfer_snn"
 *
 * Transfer packet to SNN
 *
 */
static void transfer_handler(int nb_params, char **params)
{
	char *c;
	unsigned int *addr_output;		//address for status reg
	unsigned int *addr_value;		//address for value mem
	unsigned int *addr_num_input;	//address for number input
	void *addr_packet_in;			//address for packet_in
	//void *addr_tick;				//address for tick
	void *addr_status;				// status : [output-valid] [tick]  [input_buf_empty] [ren2in_buf]
	//unsigned int count;
	//unsigned int size;
	//unsigned int packet_in;
	unsigned int num_pic;
	unsigned int i, p;

	if (nb_params < 4) {
		//							>0<					>1<					>2<				>3<					>4<				>5<					>6<
		printf("transfer_snn <address_status> <address_packet_in> <address_packet_out> <address_value> <address_num_input> <num_picture>");
		return;
	}
	//size = 4;
	// if (nb_params == 9) {
	// 	count = 1;
	// } else {
	// 	count = strtoul(params[9], &c, 0);
	// 	if(*c != 0) {
	// 		printf("\nIncorrect count");
	// 		return;
	// 	}
	// }
	// if (nb_params == 11)
	//	size = strtoul(params[10], &c, 0);
	//dump_bytes(addr, length, (unsigned long)addr);

	printf("Start \n");
	//Transfer
	//status
	addr_status = (void *)strtoul(params[0], &c, 0);
		if (*c != 0) {
			printf("Incorrect address");
			return;
		}
	//packet in
	addr_packet_in = (void *)strtoul(params[1], &c, 0);
		if (*c != 0) {
			printf("Incorrect address");
			return;
		}
	//ouput
	addr_output = (unsigned int *)strtoul(params[2], &c, 0);
		if (*c != 0) {
			printf("Incorrect address");
			return;
		}
	//tick
	// addr_tick = (void *)strtoul(params[3], &c, 0);
	// 	if (*c != 0) {
	// 		printf("Incorrect address");
	// 		return;
	// 	}
	
	//value
	addr_value = (unsigned int *)strtoul(params[3], &c, 0);
		if (*c != 0) {
			printf("Incorrect address");
			return;
		}

	//number input
	addr_num_input = (unsigned int *)strtoul(params[4], &c, 0);
		if (*c != 0) {
			printf("Incorrect address");
			return;
		}
	//Number picture
	num_pic = strtoul(params[5], &c, 0);
		if (*c != 0) {
			printf("Incorrect address");
			return;
		}

	for (i = 0; i<num_pic; i++)
	{
		printf("Begin %d\n", i);
		//status = *addr_status;
		// if (*addr_status == 0)
		// {
		// 	*(uint32_t *)addr_input_buf_empty = 0;
		// 	for(p = 0; p<10; p++ )
		// 	{
		// 		//ren2in_buf = *addr_ren2in_buf;
		// 		if (*addr_ren2in_buf == 1)
		// 		{
		// 			*(uint32_t *)addr_wr		= wr_addr;
		// 			*(uint32_t *)addr_packet_in = packet_in;
		// 			wr_addr++;
		// 			packet_in++;
		// 			printf("%ld ", *(uint32_t *)addr_packet_in);
		// 		}
		// 	}
		// 	*(uint32_t *)addr_input_buf_empty 	= 1;
		// 	*(uint32_t *)addr_tick				= 1;
		// 	*addr_status						= 1;
		// }
		// if (*addr_status == 1)
		// {
		// 	while (*addr_output_valid != 1)
		// 	{
		// 		printf(". ");
		// 	}
		// 	*addr_status 			= 0;
		// 	printf("\n");
		// }

		*(uint32_t *)addr_status = 0;
		for (p = 0; p < *addr_num_input; p++)
		{
			if (*(uint32_t *)addr_status == 1)
			{
				*(uint32_t *)addr_packet_in = *addr_value;
				addr_value += 4; 
			}
		}
		*(uint32_t *)addr_status = 2;
		while (*(uint32_t *)addr_status != 4)
		{
			printf(".");
		}
		printf("\n");
		while (*(uint32_t *)addr_status != 4)
		{
			if (*(uint32_t *)addr_status == 8)
			{
				printf("%ld ", *(uint32_t *)addr_output);
			}
		}
		addr_num_input +=4;
	}
}

define_command(transfer_snn, transfer_handler, "Transfer data to SNN", MEM_CMDS);

/**
 * Command "mem_copy"
 *
 * Memory copy
 *
 */
static void mem_copy_handler(int nb_params, char **params)
{
	char *c;
	unsigned int *dstaddr;
	unsigned int *srcaddr;
	unsigned int count;
	unsigned int i;

	if (nb_params < 2) {
		printf("mem_copy <dst> <src> [count]");
		return;
	}

	dstaddr = (unsigned int *)strtoul(params[0], &c, 0);
	if (*c != 0) {
		printf("Incorrect destination address");
		return;
	}

	srcaddr = (unsigned int *)strtoul(params[1], &c, 0);
	if (*c != 0) {
		printf("Incorrect source address");
		return;
	}

	if (nb_params == 2) {
		count = 1;
	} else {
		count = strtoul(params[2], &c, 0);
		if (*c != 0) {
			printf("Incorrect count");
			return;
		}
	}

	for (i = 0; i < count; i++)
		*dstaddr++ = *srcaddr++;
}

define_command(mem_copy, mem_copy_handler, "Copy address space", MEM_CMDS);

/**
 * Command "mem_test"
 *
 * Memory Test
 *
 */
static void mem_test_handler(int nb_params, char **params)
{
	char *c;
	unsigned int *addr;
	unsigned long maxsize = ~0uL;

	if (nb_params < 1) {
		printf("mem_test <addr> [<maxsize>]");
		return;
	}

	addr = (unsigned int *)strtoul(params[0], &c, 0);
	if (*c != 0) {
		printf("Incorrect address");
		return;
	}

	if (nb_params >= 2) {
		maxsize = strtoul(params[1], &c, 0);
		if (*c != 0) {
			printf("Incorrect size");
			return;
		}

	}

	memtest(addr, maxsize);
}
define_command(mem_test, mem_test_handler, "Test memory access", MEM_CMDS);

/**
 * Command "mem_speed"
 *
 * Memory Speed
 *
 */
static void mem_speed_handler(int nb_params, char **params)
{
	char *c;
	unsigned int *addr;
	unsigned long size;
	bool read_only = false;
	bool random = false;

	if (nb_params < 2) {
		printf("mem_speed <addr> <size> [<readonly>] [<random>]");
		return;
	}

	addr = (unsigned int *)strtoul(params[0], &c, 0);
	if (*c != 0) {
		printf("Incorrect address");
		return;
	}

	size = strtoul(params[1], &c, 0);
	if (*c != 0) {
		printf("Incorrect size");
		return;
	}

	if (nb_params >= 3) {
		read_only = (bool) strtoul(params[2], &c, 0);
		if (*c != 0) {
			printf("Incorrect readonly value");
			return;
		}
	}

	if (nb_params >= 4) {
		random = (bool) strtoul(params[3], &c, 0);
		if (*c != 0) {
			printf("Incorrect random value");
			return;
		}
	}

	memspeed(addr, size, read_only, random);
}
define_command(mem_speed, mem_speed_handler, "Test memory speed", MEM_CMDS);

/**
 * Command "mem_cmp"
 *
 * Memory Compare
 *
 */
static void mem_cmp_handler(int nb_params, char **params)
{
        char *c;
        unsigned int *addr1;
        unsigned int *addr2;
        unsigned int count;
        unsigned int i;
	bool same = true;
        if (nb_params < 3) {
                printf("mem_cmp <addr1> <addr2> <count>");
                return;
        }

        addr1 = (unsigned int *)strtoul(params[0], &c, 0);
        if (*c != 0) {
                printf("Incorrect addr1");
                return;
        }

        addr2 = (unsigned int *)strtoul(params[1], &c, 0);
        if (*c != 0) {
                printf("Incorrect addr2");
                return;
        }

        count = strtoul(params[2], &c, 0);
        if (*c != 0) {
		printf("Incorrect count");
		return;
        }

        for (i = 0; i < count; i++)
                if (*addr1++ != *addr2++){
			printf("Different memory content:\naddr1: 0x%08lx, content: 0x%08x\naddr2: 0x%08lx, content: 0x%08x\n",
					(long unsigned int)(addr1 - 1), *(addr1 - 1),
					(long unsigned int)(addr2 - 1), *(addr2 - 1));
			same = false;
		}

	if (same)
		printf("mem_cmp finished, same content.");
	else
		printf("mem_cmp finished, different content.");
}
define_command(mem_cmp, mem_cmp_handler, "Compare memory content", MEM_CMDS);

