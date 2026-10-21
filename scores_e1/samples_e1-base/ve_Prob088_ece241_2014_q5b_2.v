
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    state_t state;

    
    reg [1:0] state_one_hot;

    
    reg z_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state = A;
            state_one_hot = 2'b00;
            z_reg = 1'b0;
        end else begin
            case (state)
                A: begin
                    if (x == 1'b0) begin
                        state = A;
                        state_one_hot = 2'b00;
                        z_reg = 1'b0;
                    end else begin
                        state = B;
                        state_one_hot = 2'b01;
                        z_reg = 1'b1;
                    end
                end
                B: begin
                    if (x == 1'b0) begin
                        state = B;
                        state_one_hot = 2'b01;
                        z_reg = 1'b1;
                    end else begin
                        state = A;
                        state_one_hot = 2'b00;
                        z_reg = 1'b0;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z = 1'b0;
        end else begin
            z = z_reg;
        end
    end

endmodule
