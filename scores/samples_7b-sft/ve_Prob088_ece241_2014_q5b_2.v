
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    localparam [1:0] A = 2'b10;
    localparam [1:0] B = 2'b01;

    reg [1:0] state_reg, next_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state_reg <= A;
        else
            state_reg <= next_state;
    end

    
    always @(*) begin
        case (state_reg)
            A: next_state = x ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end

    
    assign z = (state_reg == A) ? x : ~x;

endmodule
