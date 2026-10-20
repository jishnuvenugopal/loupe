
module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    
    parameter B = 1'b0;
    parameter A = 1'b1;

    
    reg state, next_state;

    
    assign out = (state == B) ? 1'b1 : 1'b0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= B;
  
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case(state)
            B: begin
                if (in == 1'b0) begin
                    next_state = B;
                end else begin
                    next_state = B;
                end
            end
            A: begin
                if (in == 1'b0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            default: begin
                next_state = B;
  
            end
        endcase
    end

endmodule
