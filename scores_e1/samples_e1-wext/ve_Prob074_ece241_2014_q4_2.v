
module TopModule (
    input clk,
    input x,
    output reg z
);

    
    reg [1:0] q1, q2, q3;

    
    reg [1:0] xnor_output;

    
    enum reg [1:0] {IDLE, XOR, AND, OR} state;

    
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                q1 <= 2'b00;
                q2 <= 2'b00;
                q3 <= 2'b00;
                state <= XOR;
            end
            XOR: begin
                q1 <= x;
                q2 <= ~q1;
                q3 <= q1 ^ q2;
                state <= AND;
            end
            AND: begin
                q1 <= q2;
                q2 <= ~q1;
                q3 <= q1 & q2;
                state <= OR;
            end
            OR: begin
                q1 <= q2;
                q2 <= ~q1;
                q3 <= q1 | q2;
                state <= XOR;
            end
        endcase
    end

    
    assign z = xnor_output;

endmodule
