
module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] state, next_state;

    
    localparam S0 = 0,
               S1 = 1,
               S2 = 2,
               S3 = 3,
               DONE = 4;

    
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    
    always @* begin
        case (state)
            S0:
                next_state = data ? S1 : S0;
            S1:
                next_state = data ? S2 : S0;
            S2:
                next_state = data ? S1 : S3;
            S3:
                next_state = data ? DONE : S0;
            DONE:
                next_state = DONE;
            default:
                next_state = S0;
        endcase
    end

    
    assign start_shifting = (state == DONE);

endmodule
