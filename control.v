`timescale 1ns/1ns


module control(
	clock, resetn,
	begin_game,
	fruit_colour,
	fruit_x_position, fruit_y_position, 
	fruit_drawn, background_drawn,
	
	mouse_x, mouse_y,
	mouse_left_click,
	
	new_fruit, move_fruit,
	draw_fruit, draw_start_background, draw_background, draw_gameover_background,
	gameover,
	remove_fruit,
	number_of_fruits_cut
);
			
	input clock, resetn;
	input begin_game;
	input [23:0]fruit_colour;
	input [7:0]fruit_x_position;
	input [6:0]fruit_y_position;
	input fruit_drawn;
	input background_drawn;
	
	input [7:0]mouse_x;
	input [7:0]mouse_y;
	input mouse_left_click;
	
	output reg new_fruit;
	output reg move_fruit;
	output reg draw_fruit;
	output reg draw_background;
	output reg draw_start_background;
	output reg draw_gameover_background;
	output reg gameover;
	output reg remove_fruit;
	output reg [7:0]number_of_fruits_cut;
	
	reg [3:0] current_state;
	
	
	
	
	localparam  BEGIN_GAME				= 3'd0,
					BEGIN_GAME_WAIT		= 3'd1,
					DISPLAY_BACKGROUND	= 3'd2,
					START_POS				= 3'd3,
					MOVE 						= 3'd4,
					DISPLAY_FRUIT 			= 3'd5,
					COLLISION				= 3'd6,
					GAMEOVER 				= 3'd7;
	/*
			(state_0) -> BEGIN_GAME: Prints the background 
			
			(state_1) -> BEGIN_GAME_WAIT: Wait for user to release button
			
			(state_2) -> DISPLAY_BACKGROUND
			
			(state_3) -> START_POS
			
			(state_4) -> MOVE
			
			(state_5) -> DISPLAY_FRUIT
			
			(state_6) -> COLLISION
			
			(state_7) -> GAMEOVER
	*/
	
	
	reg [3:0] next_state;
	reg mouse_clicked;	 
	
	wire frame_enable;
	reg [3:0]frame_counter;
	localparam FRAME_RATE = 10;

	
	clock_divider divider(
			.Clock(clock),
			.Resetn(resetn),
			.Enable(frame_enable)
	);

	
	
	
	always @(*) begin
		case (current_state)
		
			BEGIN_GAME: next_state = (!begin_game) ? BEGIN_GAME_WAIT : BEGIN_GAME;
			
			BEGIN_GAME_WAIT: next_state = (!begin_game) ? BEGIN_GAME_WAIT: DISPLAY_BACKGROUND;
			
			DISPLAY_BACKGROUND: begin 
				if (background_drawn && !gameover)
					next_state = new_fruit ? START_POS : MOVE;
				else 
					next_state = DISPLAY_BACKGROUND;
			end
			
			START_POS: next_state = DISPLAY_FRUIT;
			
			
			MOVE: begin 
				if (remove_fruit) 
					next_state = COLLISION;
					
				else if (gameover)
					next_state = GAMEOVER;
					
				else 
					next_state = DISPLAY_FRUIT;
			end
			
			DISPLAY_FRUIT: next_state = (fruit_drawn && frame_counter >= FRAME_RATE)? DISPLAY_BACKGROUND : DISPLAY_FRUIT;
			
			COLLISION: next_state = DISPLAY_BACKGROUND;
			
			GAMEOVER: next_state = GAMEOVER;
			

			default: next_state = BEGIN_GAME;
		endcase
	end
	

	// state_characteristics
	always @(posedge clock) begin 
		if (!resetn) begin
			current_state 		<= BEGIN_GAME;
			frame_counter	  	<= 0;
			new_fruit 			<= 0;
			mouse_clicked 		<= 0;
			number_of_fruits_cut <= 0;
		end
		
		
		else begin
			current_state <= next_state;
			
			
			if (current_state == MOVE && next_state != MOVE) begin
				mouse_clicked <= 0;
			end
			
			else if (mouse_left_click) begin
				mouse_clicked <= 1;
			end
			
			
			if (next_state == BEGIN_GAME_WAIT) begin
				new_fruit <= 1;
			end 
			
			else if (next_state == DISPLAY_FRUIT) begin
				if (current_state != DISPLAY_FRUIT)
					frame_counter <= 0;
					
				else if (frame_enable)
					frame_counter <= frame_counter + 1;
			
				if (new_fruit)
					new_fruit <= 0;
			end //else if

			else if (next_state == COLLISION) begin
				new_fruit <= 1;
				if (number_of_fruits_cut <= 255)
					number_of_fruits_cut <= number_of_fruits_cut + 1;
			end 
			
		end //else
		
	end //always
			
			
	// outputs
	always @(*) begin
		move_fruit 				 	 = 0;
		remove_fruit 			 	 = 0;
		gameover 				 	 = 0;
		draw_start_background 	 = 0;
		draw_background 		 	 = 0;
		draw_gameover_background = 0;
		draw_fruit 				 	 = 0;
		
		case (current_state)
			
			BEGIN_GAME: begin
				draw_start_background = 1;
			end
			
			BEGIN_GAME_WAIT: begin end
		
			DISPLAY_BACKGROUND: begin
				draw_background = 1;
			end
			
			START_POS: begin end
				
			MOVE: begin		
				
				move_fruit = 1;
				
				//Change collision boundaries here
				
				if (fruit_y_position >= 104) begin
					gameover 	 = 1;
				end
				
				else if ((fruit_x_position <= mouse_x && mouse_x <= fruit_x_position + 15)
						&& (fruit_y_position <= mouse_y && mouse_y <= fruit_y_position + 15)
						&& (mouse_clicked)) 
					remove_fruit = 1;

			end
			
			DISPLAY_FRUIT: begin
				draw_fruit = 1;

			end
				
			COLLISION: begin end
			
			GAMEOVER: begin 
					draw_gameover_background = 1;
			end			
			default: begin end
			
		endcase
	end //always
			
endmodule


