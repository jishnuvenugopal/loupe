
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    typedef enum {A, B} state_t;

    
    reg [1:0] current_state;

    
    reg [1:0] state_A;
    reg [1:0] state_B;

    
    reg z;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
            state_A <= 2'b00;
            state_B <= 2'b00;
            z <= 1'b0;
        end else begin
            case (current_state)
                A: begin
                    if (x == 1'b0) begin
                        state_A <= 2'b00;
                        state_B <= 2'b00;
                        z <= 1'b0;
                    end else begin
                        state_A <= 2'b01;
                        state_B <= 2'b00;
                        z <= 1'b1;
                    end
                end
                B: begin
                    if (x == 1'b0) begin
                        state_A <= 2'b00;
                        state_B <= 2'b00;
                        z <= 1'b0;
                    end else begin
                        state_A <= 2'b00;
                        state_B <= 2'b01;
                        z <= 1'b1;
                    end
                end
            endcase
        end
    end

    
    assign z = current_state == 2'b01;

endmodule
