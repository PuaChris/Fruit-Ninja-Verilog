`timescale 1ns/1ns

module datapath(
	clock, resetn,
						
	x_in, y_in, colour_in,		
	
	new_fruit,
	ld_xy,
	ld_background,
				
	counter4bit,
	counter7bit,
	bg_counter,

	frame_rate,
	
	x_pos, y_pos, 
	colour_out
	);
				
				
	input clock;
	input resetn;
	input [7:0]x_in;
	input [6:0]y_in;
	input [2:0]colour_in;
	
	input new_fruit;
	input ld_xy;
	input ld_background;
	
	input [3:0] counter4bit;
	input [6:0] counter7bit;
	input [15:0] bg_counter;
	
	output reg [4:0]frame_rate;
	
	output [7:0]x_pos;
	output [6:0]y_pos;
	output reg [2:0]colour_out;
		
	reg [7:0]x_wire;
	reg [6:0]y_wire;

	wire [2:0]bg_colour;
	
	localparam FRAME_RATE = 15;
	
	wire frame_enable;
	clock_divider divider(
			.Clock(clock),
			.Resetn(resetn),
			.Enable(frame_enable)
			);
			
	background background (
			.clock (clock),
			.wren (0),
			.address(bg_counter),
			.q (bg_colour)
			);
	
	
	//async reset
	always@ (posedge clock, negedge resetn)
		begin 
			if (!resetn) begin
				frame_rate<=0;
				x_wire <= 0;
				y_wire <= 0;
				colour_out <= 0;
			end
				
			else begin
			
				if (ld_xy) begin
					if (new_fruit) begin
						x_wire <= x_in;
						y_wire <= y_in;
						colour_out <= colour_in;
					end
					
					else begin
					x_wire <= x_in;						
					y_wire <= y_in + counter7bit;
					colour_out <= colour_in;
					end
					
					
					if (frame_enable) begin
						frame_rate <= frame_rate + 1;
						
					end
					
				end				
				
				
				else if (ld_background) begin
				
					x_wire <= bg_counter[7:0];
					y_wire <= bg_counter[14:8];
					colour_out <= bg_colour;

				end
				
				else if (frame_rate >= FRAME_RATE) begin
					frame_rate <= 0;
				end
								
			end
		end
		


assign x_pos = x_wire + counter4bit[3:2];
//assign x_pos = x_wire;

assign y_pos = y_wire + counter4bit[1:0];
//assign y_pos = y_wire;

endmodule