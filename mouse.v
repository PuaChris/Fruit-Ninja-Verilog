`timescale 10ns / 10ns


module mouse(clock, reset,
				received_data, received_data_en,
				x, y, left_click);

	localparam WIDTH = 160, HEIGHT = 120, BYTE_WIDTH = 8;
	localparam XY_WIDTH = 8;		// without sign bit
	localparam DELTA_SHIFT = 1;	// to adjust speed of recorded movement

	input clock, reset;
	input [7:0] received_data;
	input received_data_en;
	output reg [XY_WIDTH - 1 : 0] x, y;
	output reg left_click;
	
	
	
	localparam	WAIT_0	= 3'b000,
					BYTE_0	= 3'b001,
					WAIT_1	= 3'b010,
					BYTE_1	= 3'b011,
					WAIT_2	= 3'b100,
					BYTE_2	= 3'b101,
					PROCESS	= 3'b110;
	
	reg [2:0] current_state, next_state;
	reg [BYTE_WIDTH - 1 : 0] byte0, byte1, byte2;
	
	
	always @(*) begin
		case (current_state)
//			WAIT_0:	next_state = received_data_en ? BYTE_0 : WAIT_0;
			WAIT_0:	next_state = (received_data_en && received_data != 8'hFA && received_data != 8'hAA && received_data != 8'hFC && received_data != 8'h00) ? BYTE_0 : WAIT_0;
//			BYTE_0:	next_state = received_data_en ? BYTE_1 : WAIT_1;
			BYTE_0:	next_state = WAIT_1;
//			BYTE_0:	next_state = BYTE_1;
			WAIT_1:	next_state = received_data_en ? BYTE_1 : WAIT_1;
//			BYTE_1:	next_state = received_data_en ? BYTE_2 : WAIT_2;
			BYTE_1:	next_state = WAIT_2;
//			BYTE_1:	next_state = BYTE_2;
			WAIT_2:	next_state = received_data_en ? BYTE_2 : WAIT_2;
			BYTE_2:	next_state = PROCESS;
			PROCESS:	next_state = WAIT_0;
			default:	next_state = WAIT_0;
		endcase
	end
	
	
	always @(posedge clock) begin
		if (reset) begin
			x <= 0;
			y <= 0;
			left_click <= 0;
			
			byte0 <= 0;
			byte1 <= 0;
			byte2 <= 0;
			
			current_state <= WAIT_0;
		end
		
		
		else begin
			current_state <= next_state;
			
			if (next_state == BYTE_0) begin
				byte0 <= received_data;
			end
			
			else if (next_state == BYTE_1) begin
				byte1 <= received_data;
			end
			
			else if (next_state == BYTE_2) begin
				byte2 <= received_data;
			end
			
			else if (next_state == PROCESS) begin
				// >>> or <<< are signed bit shift
				if (						(	$signed({1'b0, x}) + ($signed({byte0[4], byte1}) >>> DELTA_SHIFT)	) >= WIDTH )
					x <= WIDTH - 1;
				else if (				(	$signed({1'b0, x}) + ($signed({byte0[4], byte1}) >>> DELTA_SHIFT)	) < 0 )
					x <= 0;
				else
					x <= $unsigned		(	$signed({1'b0, x}) + ($signed({byte0[4], byte1}) >>> DELTA_SHIFT)	);
					
					
				if (						(	$signed({1'b0, y}) - ($signed({byte0[5], byte2}) >>> DELTA_SHIFT)	) >= HEIGHT	)
					y <= HEIGHT - 1;
				else if (				(	$signed({1'b0, y}) - ($signed({byte0[5], byte2}) >>> DELTA_SHIFT)	) < 0 )
					y <= 0;
				else
					y <= $unsigned		(	$signed({1'b0, y}) - ($signed({byte0[5], byte2}) >>> DELTA_SHIFT)	);
				
				left_click <= byte0[0];
			end
		end
	end
	
endmodule
	

