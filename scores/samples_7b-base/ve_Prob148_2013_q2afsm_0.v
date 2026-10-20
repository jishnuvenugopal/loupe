
module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);


localparam A = 3'b000,
           B = 3'b001,
           C = 3'b010,
           D = 3'b011;


reg [2:0] state, next_state;


always @(posedge clk or negedge resetn) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end


always @(*) begin
    case (state)
        A: begin
            if (r == 3'b001)
                next_state = B;
            else if (r == 3'b010)
                next_state = C;
            else if (r == 3'b011)
                next_state = D;
            else
                next_state = A;
        end
        B: begin
            if (r == 3'b001)
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            if (r == 3'b010)
                next_state = C;
            else
                next_state = A;
        end
        D: begin
            if (r == 3'b000)
                next_state = D;
            else
                next_state = A;
        end
    endcase
end


always @(*) begin
    case (state)
        A: begin
            if (r == 3'b001)
                g = 3'b001;
            else if (r == 3'b010)
                g = 3'b010;
            else if (r == 3'b011)
                g = 3'b100;
            else
                g = 3'b000;
        end
        B: g = 3'b001;
        C: g = 3'b010;
        D: g = 3'b100;
    endcase
end

endmodule
