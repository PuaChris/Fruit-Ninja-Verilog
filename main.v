`timescale 1ns / 1ns

module main(
			clock,
			resetn,
			begin_game,
			
			received_data, received_data_en,
			
			colour_out,
			x_out, y_out,
			plot,
			
			number_of_fruits_cut
			);
	
	input clock;
	input resetn;
	input begin_game;
	
	// PS2
	input	[7:0]	received_data;
	input		 	received_data_en;
	
	output reg [23:0]colour_out;
	output reg [7:0]x_out;
	output reg [6:0]y_out;
	output reg plot;

	output [7:0] number_of_fruits_cut;
	
	localparam MOUSE_COLOUR = 24'd16_777_215;
	
	wire new_fruit;
	wire move_fruit;
	wire draw_fruit;
	wire fruit_drawn;
	
	wire draw_start_background;
	wire draw_background;
	wire draw_gameover_background;
	wire gameover;
	wire background_drawn;
	wire [7:0]fruit_x_position;
	wire [6:0]fruit_y_position;
	wire [7:0]fruit_x_out;
	wire [6:0]fruit_y_out;
	wire [23:0]fruit_colour;
	
	wire [7:0]background_x_position;
	wire [6:0]background_y_position;
	wire [23:0]background_colour;
	
	wire remove_fruit;
	
		
	wire [7:0] mouse_x, mouse_y;
	wire mouse_left_click;
	
	reg is_mouse_plotted;
	reg [7:0] mouse_x_plotted;
	reg [7:0] mouse_y_plotted;
	
	
	
	
	fruit_datapath fruit_datapath(
				//inputs
				.clock(clock),
				.resetn(resetn),
				.new_fruit(new_fruit),
				.draw_fruit(draw_fruit),
				.move_fruit(move_fruit),
				.number_of_fruits_cut(number_of_fruits_cut),
				
				//outputs
				
				.fruit_x_position(fruit_x_position),
				.fruit_y_position(fruit_y_position),
				
				.fruit_x_out(fruit_x_out),
				.fruit_y_out(fruit_y_out),
				
				.fruit_colour(fruit_colour),
				.fruit_drawn(fruit_drawn)
				);
				
	background_datapath background_datapath(
				//inputs
				.clock(clock),
				.resetn(resetn),
				.draw_start_background(draw_start_background),
				.draw_background(draw_background),		
				.draw_gameover_background(draw_gameover_background),			
				.gameover(gameover),
				
				//outputs
				.background_x_position(background_x_position),
				.background_y_position(background_y_position),
				.background_colour(background_colour),
				.background_drawn(background_drawn)
				);

	control control(
				//inputs
				.clock(clock),
				.resetn(resetn),
				.begin_game(begin_game),
				
				.fruit_colour(colour_out),
				.fruit_x_position(fruit_x_position),
				.fruit_y_position(fruit_y_position),
				.fruit_drawn(fruit_drawn),
				.background_drawn(background_drawn),
				
				.mouse_x(mouse_x), 
				.mouse_y(mouse_y),
				.mouse_left_click(mouse_left_click),
				
				//outputs
				.new_fruit(new_fruit),
				.move_fruit(move_fruit),
				.draw_fruit(draw_fruit),
				.draw_start_background(draw_start_background),
				.draw_background(draw_background),
				.draw_gameover_background(draw_gameover_background),
				.gameover(gameover),
	
				.remove_fruit(remove_fruit),
				.number_of_fruits_cut(number_of_fruits_cut)		
	);
				
	mouse m(	.clock(clock), .reset(~resetn),				
				.received_data(received_data), .received_data_en(received_data_en),
				.x(mouse_x), .y(mouse_y), .left_click(mouse_left_click)
	);

	
	always @(posedge clock) begin		
		if (!resetn) begin
			x_out 	  <= 0;
			y_out 	  <= 0;
			colour_out <= 0;
			plot <= 0;
			
			is_mouse_plotted <= 0;
			mouse_x_plotted <= 0;
			mouse_y_plotted <= 0;
		end //if

		else if (draw_fruit && !fruit_drawn) begin
			x_out		  <= fruit_x_out;
			y_out 	  <= fruit_y_out;
			colour_out <= fruit_colour;
			
			if (fruit_colour != 0) begin
				plot <= 1;
			end
			
			else plot <= 0;
			
		end //if
	
		else if (draw_background || draw_start_background || draw_gameover_background) begin
			x_out		  <= background_x_position;
			y_out		  <= background_y_position;
			colour_out <= background_colour;
			plot <= 1;
		end //if
		
		else 	begin
			if (is_mouse_plotted) begin
				x_out <= mouse_x_plotted;
				y_out <= mouse_y_plotted;
				colour_out <= MOUSE_COLOUR;
				plot <= 1;
				
				is_mouse_plotted <= 0;
			end
			
			else begin
				x_out <= mouse_x;
				y_out <= mouse_y[6:0];
				colour_out <= MOUSE_COLOUR;
				plot <= 1;
				
				is_mouse_plotted <= 1;
				mouse_x_plotted <= mouse_x;
				mouse_y_plotted <= mouse_y;
			end
		end

	end
	
endmodule


