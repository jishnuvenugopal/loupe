
module TopModule (
    input clk,
    input x,
    output reg z
);

    
    enum reg [1:0] {S0, S1, S2} state;

    
    reg [1:0] d0, d1, d2;

    
    always @(*) begin
        z = (d0 ^ d1) ^ d2;
    end

    
    always @(posedge clk) begin
        case (state)
            S0: begin
                d0 <= x;
                d1 <= ~x;
                d2 <= ~x;
                state <= S1;
            end
            S1: begin
                d0 <= x;
                d1 <= ~x;
                d2 <= ~x;
                state <= S2;
            end
            S2: begin
                d0 <= x;
                d1 <= ~x;
                d2 <= ~x;
                state <= S0;
            end
        endcase
    end

endmodule
