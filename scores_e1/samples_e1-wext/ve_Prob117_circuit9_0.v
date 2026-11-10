
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    
    enum reg [1:0] {state0, state1} state;

    
    initial begin
        state <= state0;
        q <= 3'b111;
 
    end

    
    always @(posedge clk) begin
        case (state)
            state0: begin
                if (a == 0) begin
                    state <= state1;
                    q <= 3'b111;
                end else begin
                    state <= state0;
                    q <= 3'b000;
                end
            end
            state1: begin
                if (a == 0) begin
                    state <= state0;
                    q <= 3'b111;
                end else begin
                    state <= state1;
                    q <= 3'b000;
                end
            end
        endcase
    end

endmodule
