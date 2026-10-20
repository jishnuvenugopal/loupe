
module TopModule (
    input [2:0] a,
    output [15:0] q
);

    
    reg [15:0] register;

    
    always @(*) begin
        case (a)
            3'b000: register = 1232;
            3'b001: register = 16#AEE0;
            3'b010: register = 16#27D4;
            3'b011: register = 16#5A0E;
            3'b100: register = 16#2066;
            3'b101: register = 16#64CE;
            3'b110: register = 16#C526;
            3'b111: register = 16#2F19;
            default: register = 1232;
 
        endcase
    end

    
    assign q = register;

endmodule
