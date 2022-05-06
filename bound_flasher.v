module bound_flasher(flick, clk, rst, led);
	input wire flick;
	input wire clk;
	input wire rst;
	output wire [15:0] led;
	
parameter INIT 	    = 9'b000000001,
		      ON_0_5 	  = 9'b000000010,
		      OFF_5_0 	= 9'b000000100,
		      ON_0_10	  = 9'b000001000,
		      OFF_10_0	= 9'b000010000,
		      OFF_10_5	= 9'b000100000,
		      ON_5_15	  = 9'b001000000,
		      OFF_5		  = 9'b010000000,
		      OFF_15_0 	= 9'b100000000;

reg [8:0] current_state, next_state;
reg [15:0] curLed;
assign led = curLed;

/*FSM*/

always @(clk or rst) begin
	if (~rst)
	begin
		current_state = INIT;
	end
	else
	begin
		current_state = next_state;
	end
end

always @(*) begin
	case (current_state)
	INIT:			begin
							if (flick) next_state = ON_0_5;
							else next_state = INIT;
						end						
	ON_0_5:		begin
							if (curLed[5]) next_state = OFF_5_0;
							else next_state = ON_0_5;
						end						
	OFF_5_0:	begin
							if (~curLed[0]) next_state = ON_0_10;
							else next_state = OFF_5_0;
						end
	ON_0_10:	begin
							if (flick)
							begin
								if (curLed[10]) next_state = OFF_10_0;
								else if (curLed[5] && ~curLed[6]) next_state = OFF_5_0;
								else next_state = ON_0_10;
							end
							else
							begin
								if (curLed[10]) next_state = OFF_10_5;
								else next_state = ON_0_10;
							end
						end
	OFF_10_0:	begin
							if (~curLed[0]) next_state = ON_0_10;
							else next_state = OFF_10_0;
						end
	OFF_10_5:	begin
							if (~curLed[5]) next_state = ON_5_15;
							else next_state = OFF_10_5;
						end					
	ON_5_15:	begin
							if (flick)
							begin
								if (curLed[10]) next_state = OFF_10_5;
								else if (curLed[5] && ~curLed[6]) next_state = OFF_5;
								else next_state = ON_5_15;
							end
							else
							begin
								if (curLed[15]) next_state = OFF_15_0;
								else next_state = ON_5_15;
							end
						end	
	OFF_5:		begin
							if (~curLed[5]) next_state = ON_5_15;
							else next_state = OFF_5;
						end			
	OFF_15_0:	begin
							if (~curLed[0]) next_state = INIT;
							else next_state = OFF_15_0;
						end					
	default: next_state = INIT;
	endcase
end
	
/*LED*/

always @(negedge clk) begin
	case (current_state)
	INIT:			begin
							curLed <= 0;
						end				
	ON_0_5:		begin
							curLed <= (curLed << 1) | 1;
						end				
	OFF_5_0:	begin
							curLed <= curLed >> 1;
						end
	ON_0_10:	begin
							curLed <= (curLed << 1) | 1;
						end
	OFF_10_0:	begin
							curLed <= curLed >> 1;
						end
	OFF_10_5:	begin
							curLed <= curLed >> 1;
						end					
	ON_5_15:	begin
							curLed <= (curLed << 1) | 1;
						end	
	OFF_5:		begin
							curLed <= curLed >> 1;
						end					
	OFF_15_0:	begin
							curLed <= curLed >> 1;
						end						
	default: 	begin
							curLed <= 0;
						end
	endcase
end
	
endmodule
