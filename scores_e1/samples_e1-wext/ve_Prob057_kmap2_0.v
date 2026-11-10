
module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output reg out
);

    
    reg [3:0] inputRegister;

    
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            inputRegister <= 4'b0000;
            out <= 1'b0;
        end else begin
            inputRegister <= {a, b, c, d};
            out <= inputRegister[3];
 
        end
    end

endmodule
