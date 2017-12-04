module background_datapath (
	clock,
	resetn,
	
	draw_start_background,
	draw_background,		
	draw_gameover_background,
	gameover,
	
	background_drawn,
	background_x_position,
	background_y_position,
	background_colour
);
			
	
	input clock, resetn;
	input draw_start_background;
	input draw_background;
	input draw_gameover_background;
	input gameover;
	
	output reg background_drawn;
	output reg [7:0]background_x_position;
	output reg [6:0]background_y_position;
	output reg [23:0]background_colour;

	localparam WIDTH = 160, HEIGHT = 120;
	
	wire [23:0]get_start_background_colour;
	wire [23:0]get_background_colour;
	wire [23:0]get_gameover_background_colour;
	wire [14:0]background_counter;
	assign background_counter = background_x_position + (background_y_position * WIDTH);

	start_background start_background (
			.clock(clock),
			.address(background_counter),
			.q(get_start_background_colour)
			);	
	
	background background (
			.clock(clock),
			.wren (1'b0),
			.data(23'b0),
			.address(background_counter),
			.q(get_background_colour)
			);

	gameover_background gameover_background (
			.clock(clock),
			.address(background_counter),
			.q(get_gameover_background_colour)
			);				
			
	always @(posedge clock, negedge resetn) begin
		
		if (!resetn) begin
			background_drawn		 <= 1'b0;
			background_x_position <= 8'd0;
			background_y_position <= 7'd0;
			background_colour     <= 23'd0;
		end
		
		else if (gameover) begin
			background_drawn		 <= 1'b0;
			background_x_position <= 8'd0;
			background_y_position <= 7'd0;
			background_colour     <= 23'd0;
		end
		
		else if (draw_background || draw_start_background || draw_gameover_background) begin
			if (background_counter >= (WIDTH * HEIGHT - 1)) begin
//			if (background_counter >= 12) begin // for simulation
				background_drawn <= 1;
				
				background_x_position <= 0;
				background_y_position <= 0;
			end
				
			else begin
				background_drawn <= 0;
				
				if (background_x_position >= WIDTH - 1) begin
					background_x_position <= 0;
					background_y_position <= background_y_position + 1;
				end
				else begin
					background_x_position <= background_x_position + 1;
				end
			end //else
			
			if (draw_start_background)
				background_colour <= get_start_background_colour;
			
			else if (draw_gameover_background) 
				background_colour <= get_gameover_background_colour;
				
			else if (draw_background)
				background_colour <= get_background_colour;
				
		end //if
		
	end // always
	
endmodule



