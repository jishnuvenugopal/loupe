
module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    
    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;

    
    reg [1:0] currentState, nextState;

    
    reg z_reg;

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            currentState <= S0;
            z_reg <= 1'b0;
        end else begin
            currentState <= nextState;
            z_reg <= (nextState == S2) ? 1'b1 : 1'b0;
        end
    end

    
    always @(*) begin
        case (currentState)
            S0:
                if (x == 1'b1)
                    nextState = S1;
                else
                    nextState = S0;
            S1:
                if (x == 1'b0)
                    nextState = S2;
                else
                    nextState = S0;
            S2:
                if (x == 1'b1)
                    nextState = S1;
                else
                    nextState = S0;
            default:
                nextState = S0;
        endcase
    end

    
    assign z = z_reg;

endmodule
