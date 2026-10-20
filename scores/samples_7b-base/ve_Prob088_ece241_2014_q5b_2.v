
module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    
    parameter StateA = 2'b001;
    parameter StateB = 2'b010;

    
    reg [1:0] state;

    
    reg out_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= StateA;
 
            out_reg <= 1'b0;
 
        end else begin
            case (state)
                StateA:
                    if (x == 1'b1) begin
                        state <= StateB;
 
                    end
                StateB:
                    if (x == 1'b0) begin
                        state <= StateB;
 
                    end
                default:
                    state <= StateA;
 
            endcase
        end
    end

    
    always @(posedge clk) begin
        case (state)
            StateA: out_reg <= 1'b0;
 
            StateB: out_reg <= 1'b1;
 
        endcase
    end

    
    assign z = out_reg;

endmodule
