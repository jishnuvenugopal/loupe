
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    
    typedef enum {B, A} State_t;

    
    State_t current_state;

    
    reg out;

    
    initial begin
        current_state = B;
        out = 1'b1;
 
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state = B;
            out = 1'b1;
 
        end else begin
            case (current_state)
                B: begin
                    if (in == 0) begin
                        current_state = A;
                        out = 1'b0;
 
                    end else begin
                        current_state = B;
                        out = 1'b1;
 
                    end
                end
                A: begin
                    if (in == 0) begin
                        current_state = B;
                        out = 1'b1;
 
                    end else begin
                        current_state = A;
                        out = 1'b0;
 
                    end
                end
            endcase
        end
    end

endmodule
