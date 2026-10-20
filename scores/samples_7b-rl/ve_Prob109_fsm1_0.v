
module TopModule (
    input clk,
    input areset,
    input in,
    output out
);
    reg state_reg;
    parameter B = 1;
 
    parameter A = 0;
 
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= B;
 
        end else begin
            case (state_reg)
                B: state_reg <= (in == 0) ? A : B;
 
                A: state_reg <= (in == 0) ? B : A;
 
                default: state_reg <= B;
 
            endcase
        end
    end
    
    assign out = state_reg;
 
endmodule
