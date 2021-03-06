// Part 2 skeleton

module project
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [17:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = SW[0];
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	wire newCLK;
	assign writeEn = SW[1];
	
	RateDivider RD(.enable(1'b1), .clk(CLOCK_50), .clear(1'b0), .out(newCLK));
	
	datapath DATA(
    .clk(newCLK),
    .resetn(SW[0]),
	 .up(KEY[2]),
	 .down(KEY[1]),
	 .left(KEY[3]),
	 .erase(SW[15]), 
	 .right(KEY[0]),
    .clr_in(SW[9:7]),
    .x(x),
    .y(y),
    .clr(colour)
    );
	 

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

    
endmodule


module datapath(
    input clk,
    input resetn,
	 input up,
	 input down,
	 input left,
	 input erase,
	 input right,
    input [9:7] clr_in,
    output reg [7:0] x,
    output reg [6:0] y,
    output reg [2:0] clr
    );
		reg [3:0] counter;
		reg [7:0] old_x;
		reg [6:0] old_y;
    initial begin
    	old_x <= 8'b01010000;
    	old_y <= 7'b0111100;
		x <= 8'b01010000;
		y <= 7'b0111100;
		end
    // Output result register
    always@(posedge clk) begin
		  if(erase)begin
				clr <= 3'b000;
			end
		  else
		  begin
				clr <= clr_in;
		  end
	
        if (!left) begin
				if(x > 10)begin
					x<= old_x - 1;
					old_x <= x;
					y <= old_y;
				end
        end  
		  
        if (!right) begin
				if(x < 150)begin
					x<= old_x + 1;
					old_x <= x;
					y <= old_y;
				end
        end
		  
        if (!up) begin
				if(y > 10)begin
               y<= old_y - 1;
					old_y <= y;
					x <= old_x;
				end
        end
        if (!down) begin
				if(y < 110)begin
					y<= old_y + 1;
					old_y <= y;
					x <= old_x;
				end
        end
		end
endmodule

module RateDivider(enable, clk, clear, out);
	input enable, clk, clear;
	reg [28:0] counter;
	output out;
	
	always@(posedge clk)
	begin
		if(clear == 1'b1)
			counter <= 0;
		else if(counter == 0)
				counter <=  28'b10111110101111000010;
		else if(enable == 1'b1)
			counter <= counter - 1'b1;
	end
	assign out = (counter == 0);
endmodule
