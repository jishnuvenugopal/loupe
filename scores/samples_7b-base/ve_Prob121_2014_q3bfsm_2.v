
module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] state, next_state;


always @(*) begin
    next_state = state;
  

    case (state)
        3'b000: if (x == 0) next_state = 3'b000;
 else next_state = 3'b001;
        3'b001: if (x == 0) next_state = 3'b001;
 else next_state = 3'b100;
        3'b010: if (x == 0) next_state = 3'b010;
 else next_state = 3'b001;
        3'b011: if (x == 0) next_state = 3'b001;
 else next_state = 3'b010;
        3'b100: if (x == 0) next_state = 3'b011;
 else next_state = 3'b100;
    endcase
end


always @(*) begin
    case (state)
        3'b000, 3'b001, 3'b010: z = 1'b0;
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
    endcase
end


always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000;
    end else begin
        state <= next_state;
    end
end

endmodule
