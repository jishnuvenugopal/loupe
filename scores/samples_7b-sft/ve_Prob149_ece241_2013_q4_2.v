
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] previous_state;
reg [1:0] current_state;


always @(*) begin
    case (s)
        3'b111: current_state = 2'b11;
 
        3'b110: current_state = 2'b10;
 
        3'b100: current_state = 2'b01;
 
        3'b000: current_state = 2'b00;
 
        default: current_state = 2'b00;
 
    endcase
end


always @(posedge clk) begin
    if (reset)
        previous_state <= 2'b00;
 
    else
        previous_state <= current_state;
end


assign dfr = (reset) ? 1'b1 : ((current_state > previous_state) ? 1'b1 : 1'b0);
assign fr0 = (reset) ? 1'b1 : (current_state == 2'b00 || current_state == 2'b01 || current_state == 2'b10);
assign fr1 = (reset) ? 1'b1 : (current_state == 2'b00 || current_state == 2'b01);
assign fr2 = (reset) ? 1'b1 : (current_state == 2'b00);

endmodule
