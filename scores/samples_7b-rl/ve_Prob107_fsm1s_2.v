
module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;
    
    
    localparam STATE_B = 1;
    localparam STATE_A = 0;

    
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
        end else begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
            endcase
        end
    end

    
    assign out = state;

endmodule
