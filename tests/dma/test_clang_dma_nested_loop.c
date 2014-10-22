#include "assert.h"
#include "DMAAsm.h"
#include "DMAControl.h"
#include "stdint.h"

// This test simulates reading a square region from an image

uint8_t source[8][8] = {
	{  0,  0,  0,  0,   0,  0,  0,  0 },
	{  0,  0,  0,  0,   0,  0,  0,  0 },
	{  0,  0,  0,  1,   2,  3,  4,  0 },
	{  0,  0,  0,  5,   6,  7,  8,  0 },
	{  0,  0,  0,  9,  10, 11, 12,  0 },
	{  0,  0,  0,  13, 14, 15, 16,  0 },
	{  0,  0,  0,  0,   0,  0,  0,  0 },
	{  0,  0,  0,  0,   0,  0,  0,  0 }
};

uint8_t dest[16];

dma_instruction dma_program[] = {
	DMA_OP_SET(LOOP_REG_1, 3),
		DMA_OP_SET(LOOP_REG_0, 3),
			DMA_OP_TRANSFER(TS_BITS_8), // This loop transfers a row
		DMA_OP_LOOP(LOOP_REG_0, 1),
		DMA_OP_ADD(AT_SOURCE_ONLY, 4), // Skip to the start of the next row
	DMA_OP_LOOP(LOOP_REG_1, 4),
	DMA_OP_STOP
};

int test(void)
{
	dma_set_pc(dma_program);
	dma_set_source_address((uint64_t)source);
	dma_set_dest_address((uint64_t)dest);

	dma_start_transfer();

	while (!dma_ready()) {
		DEBUG_NOP();
		DEBUG_NOP();
		DEBUG_NOP();
		DEBUG_NOP();
	}

	for (uint64_t i = 0; i < 16; ++i) {
		assert(dest[i] = (i + 1));
	}

	return 0;
}