module part1 (CLOCK_50, SW, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK,
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	input [9:0] SW;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////

/***** Task 1 ********/

	assign writedata_left = readdata_left & write_ready;
	assign writedata_right = readdata_right & write_ready;

	assign read = read_ready & write_ready;
	assign write = read_ready & write_ready;

	
/***** Task 2 ********

	wire [23:0] doutMem, unfilt_left, unfilt_right; // creates temporary variables
	
	// muxes to select between CODEC value and value from memory
	mux2_1 unfiltMuxLeft (.out(unfilt_left), .i0(readdata_left), .i1(doutMem), .sel(SW[9]));
	mux2_1 unfiltMuxRight (.out(unfilt_right), .i0(readdata_right), .i1(doutMem), .sel(SW[9]));
	
	assign writedata_left = unfilt_left;
	assign writedata_right = unfilt_right;
	
	// instantiates task 2
	task2 t2 (.CLOCK_50(CLOCK_50), .reset(reset), .write(write), .dout(doutMem));
*/	

/***** Task 3 ********
		
	wire [23:0] filt_left, filt_write; // creates temporary variables
	
	// muxes to select between unfiltered and filtered audio
	mux2_1 filtMuxLeft (.out(writedata_left), .i0(unfilt_left), .i1(filt_left), .sel(SW[8]));
	mux2_1 filtMuxRight (.out(writedata_right), .i0(unfilt_right), .i1(filt_right), .sel(SW[8]));
	
	// instantiates task 3
	task3 t3 (.CLOCK_50(CLOCK_50), .reset(reset), .read_ready(read_read), .write_ready(write_ready), .din_left(unfilt_left), 
				 .din_right(unfilt_right), .dout_left(filt_left), .dout_right(filt_right));
*/
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule


