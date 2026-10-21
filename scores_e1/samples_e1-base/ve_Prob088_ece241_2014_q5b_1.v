
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    typedef enum {A, B} state_t;

    
    wire [1:0] state;

    
    reg [1:0] state_reg;

    
    reg z_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= A;
            z_reg <= 1'b0;
        end else begin
            case (state_reg)
                A: begin
                    if (x == 0) begin
                        state_reg <= A;
                        z_reg <= 1'b0;
                    end else begin
                        state_reg <= B;
                        z_reg <= 1'b1;
                    end
                end
                B: begin
                    if (x == 0) begin
                        state_reg <= B;
                        z_reg <= 1'b1;
                    end else begin
                        state_reg <= B;
                        z_reg <= 1'b0;
                    end
                end
            endcase
        end
    end

    
    assign state = state_reg;
    assign z = z_reg;

endmodule
