
module TopModule (
    input wire clk,
    input wire reset,
    output reg [9:0] q
);

    
    typedef enum {IDLE, COUNTING} CounterState;
    reg CounterState state = IDLE;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            q <= 10'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (clk) begin
                        state <= COUNTING;
                        q <= 10'b0;
                    end
                end
                COUNTING: begin
                    if (clk) begin
                        q <= q + 1'b1;
                        if (q == 10'b999) begin
                            state <= IDLE;
                        end
                    end
                end
            endcase
        end
    end

endmodule
