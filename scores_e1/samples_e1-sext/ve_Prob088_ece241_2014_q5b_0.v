
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    reg [1:0] state;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    if (x == 1) begin
                        state <= B;
                        z <= 1;
                    end else begin
                        state <= A;
                        z <= 0;
                    end
                end
                B: begin
                    if (x == 0) begin
                        state <= B;
                        z <= 1;
                    end else begin
                        state <= A;
                        z <= 0;
                    end
                end
            endcase
        end
    end

endmodule
