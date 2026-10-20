
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    
    typedef enum logic [1:0] {B, A} StateType;
    StateType current_state, next_state;

    
    initial begin
        current_state = B;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= B;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            B: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            A: begin
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
        endcase
    end

    
    assign out = current_state == B ? 1'b1 : 1'b0;

endmodule
