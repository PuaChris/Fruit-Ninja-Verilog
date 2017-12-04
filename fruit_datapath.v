

module fruit_datapath(
				clock,
				resetn,
				
				new_fruit,
				draw_fruit,
				move_fruit,
				number_of_fruits_cut,
								
				fruit_x_position,
				fruit_y_position,
				
				fruit_x_out,
				fruit_y_out,
				
				fruit_colour,
				
				fruit_drawn
	);
				
	input clock, resetn;
	input new_fruit, draw_fruit, move_fruit;
	input [7:0]number_of_fruits_cut;
	
	output reg [7:0]fruit_x_position;
	output reg [6:0]fruit_y_position;
	
	output reg [7:0]fruit_x_out;
	output reg [6:0]fruit_y_out;
	
	output reg [23:0]fruit_colour;
	output reg fruit_drawn;
	
	
	

	wire [7:0]random_xpos;		
	wire [7:0]new_random_xpos;	
	
	reg [7:0]apple_draw_counter; //px size is 256
	wire [23:0]apple_colour;
		
	lfsr2 lfsr2 (
				.clk(clock),
				.enable(new_fruit),
				.resetn(resetn),
				.out(new_random_xpos)
				);
	apple apple (
				.address(apple_draw_counter),
				.clock(clock),
				.q(apple_colour)
				);
	
	always @(posedge clock) begin
		if (!resetn) begin
			fruit_x_position 			<= 0;
			fruit_y_position 			<= 0;
			fruit_x_out 	  			<= 0;
			fruit_y_out		  			<= 0;
			fruit_colour 	  			<= 0;
			fruit_drawn 	  			<= 0;
			apple_draw_counter 		<= 0;
		end //if 
		
		
		else begin
				
			if (new_fruit) begin
				fruit_x_position 		  <= (new_random_xpos <= 156) ? (new_random_xpos) : (new_random_xpos - 156);
				fruit_y_position 		  <= 0;
				fruit_colour 			  <= apple_colour;
			end //if
			
			
			else if (move_fruit) begin
				
				// set fruit movement speed (number to add)
				if (number_of_fruits_cut <= 3)
					fruit_y_position <= fruit_y_position + 2;
				
				else if (number_of_fruits_cut > 3 && number_of_fruits_cut <= 6)
					fruit_y_position <= fruit_y_position + 6;
				
				else if (number_of_fruits_cut > 6 && number_of_fruits_cut <= 10)
					fruit_y_position <= fruit_y_position + 10;
					
				else if (number_of_fruits_cut > 10 && number_of_fruits_cut <= 15)
					fruit_y_position <= fruit_y_position + 14;
					
				else if (number_of_fruits_cut > 15 && number_of_fruits_cut <= 20)
					fruit_y_position <= fruit_y_position + 18;
					
				else if (number_of_fruits_cut > 20 && number_of_fruits_cut <= 25)
					fruit_y_position <= fruit_y_position + 22;
					
				else if (number_of_fruits_cut > 25 && number_of_fruits_cut <= 30)
					fruit_y_position <= fruit_y_position + 27;
					
				else if (number_of_fruits_cut > 30 && number_of_fruits_cut <= 35)
					fruit_y_position <= fruit_y_position + 32;
					
				else if (number_of_fruits_cut > 35 && number_of_fruits_cut <= 40)
					fruit_y_position <= fruit_y_position + 38;
					
				else if (number_of_fruits_cut > 40 && number_of_fruits_cut <= 45)
					fruit_y_position <= fruit_y_position + 45;
					
				else if (number_of_fruits_cut > 45 && number_of_fruits_cut <= 50)
					fruit_y_position <= fruit_y_position + 55;
					
				else if (number_of_fruits_cut > 50 && number_of_fruits_cut <= 55)
					fruit_y_position <= fruit_y_position + 60;
					
				else if (number_of_fruits_cut > 55 && number_of_fruits_cut <= 69)
					fruit_y_position <= fruit_y_position + 65;
					
				else if (number_of_fruits_cut > 69)
					fruit_y_position <= fruit_y_position + 69;
					
			end //else if
			
			
			else if (draw_fruit) begin

				
				fruit_x_out <= fruit_x_position + apple_draw_counter[3:0];
				fruit_y_out <= fruit_y_position + apple_draw_counter[7:4];
				
				fruit_colour <= apple_colour;
				
				if (apple_draw_counter >= 255) begin
//				if (apple_draw_counter >= 15) begin //for simulation
					fruit_drawn <= 1;
				end
				else begin
					fruit_drawn <= 0;
					apple_draw_counter <= apple_draw_counter + 1;
				end
			end //else if
			
			
			else begin
				fruit_drawn <= 0;
				apple_draw_counter <= 0;
			end
			
		end //else
		
	end //always

endmodule


