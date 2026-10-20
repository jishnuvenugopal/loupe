
module TopModule(
    input          clk,
    input          reset,
    input          data,
    output reg     start_shifting
);

    
    typedef enum reg [1:0] states_t {S0, S1, S2, S3} states_t;
    states_t current_state, next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset)
            start_shifting <= 0;
        else begin
            start_shifting <= (current_state == S3);
        end
    end

    
    always @(*) begin
        case (current_state)
            S0: begin
                if (data == 1'b1) next_state = S1;
                else              next_state = S0;
            end
            S1: begin
                if (data == 1'b1) next_state = S2;
                else              next_state = S0;
            end
            S2: begin
                if (data == 1'b0) next_state = S0;
                else              next_state = S3;
            end
            S3: begin
                
                next_state = S3;
            end
            default: next_state = S0;
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

endmodule
