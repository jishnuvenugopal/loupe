
module TopModule (
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [3:0] state;
reg [3:0] prev_state;
reg [3:0] next_state;

wire [2:0] sensors;
wire increasing;


assign sensors = s;


assign increasing = (state < next_state);











always @(s or prev_state) begin
    case ({s, prev_state})
        6'd0000: next_state = 4'b0001;
        6'd0001: next_state = (sensors == 3'b010) ? 4'b0001 : 4'b0010;
        6'd0010: next_state = (sensors == 3'b001) ? 4'b0010 : 4'b0100;
        6'd0011: next_state = 4'b0100;
        6'd0100: next_state = (sensors == 3'b000) ? 4'b0100 : 4'b0110;
        6'd0101: next_state = (sensors == 3'b011) ? 4'b0101 : 4'b1111;
        6'd0110: next_state = 4'b1111;
        default: next_state = prev_state;
    endcase
end


always @(posedge clk or posedge reset) begin
    if (reset)
        prev_state <= 4'b1111;
 
    else
        prev_state <= state;
end


always @(posedge clk or posedge reset) begin
    if (reset)
        state <= 4'b1111;
 
    else
        state <= next_state;
end


assign fr2 = state == 4'b1111;
assign fr1 = state == 4'b0110 || state == 4'b0101 || state == 4'b0100;
assign fr0 = state == 4'b0010 || state == 4'b0011 || state == 4'b0001 || state == 4'b0000;
assign dfr = increasing;

endmodule
