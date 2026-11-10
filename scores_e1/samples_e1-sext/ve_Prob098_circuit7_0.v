
module TopModule (
    input clk,
    input a,
    output reg q
);

    
    typedef enum {Q0, Q1} state_t;

    
    state_t state = Q0;

    always @(posedge clk) begin
        
        case (state)
            Q0: begin
                if (a == 0) begin
                    state <= Q0;
                end else begin
                    state <= Q1;
                end
            end
            Q1: begin
                if (a == 0) begin
                    state <= Q0;
                end else begin
                    state <= Q1;
                end
            end
        endcase

        
        case (state)
            Q0: q <= 0;
            Q1: q <= 1;
        endcase
    end

endmodule
