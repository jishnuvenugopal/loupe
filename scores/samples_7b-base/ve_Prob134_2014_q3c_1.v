
module TopModule (
    input x,
    input [2:0] y,
    output Y0,
    output z
);


reg [2:0] current_state, next_state;

always @(posedge x) begin
    current_state <= next_state;
end


always @(*) begin
    case (current_state)
        3'b000: begin
            if (x == 0) next_state = 3'b000;
            else      next_state = 3'b001;
        end
        3'b001: begin
            if (x == 0) next_state = 3'b001;
            else      next_state = 3'b100;
        end
        3'b010: begin
            if (x == 0) next_state = 3'b010;
            else      next_state = 3'b001;
        end
        3'b011: begin
            if (x == 0) next_state = 3'b001;
            else      next_state = 3'b010;
        end
        3'b100: begin
            if (x == 0) next_state = 3'b011;
            else      next_state = 3'b100;
        end
    endcase
end


assign Y0 = next_state[0];
assign z = (next_state == 3'b001 || next_state == 3'b010) ? 1 : 0;

endmodule
