
module TopModule (
    input wire in1,
    input wire in2,
    output reg out
);

    
    reg and_result;
    always @(in1 or in2) begin
        and_result = in1 & ~in2;
    end

    
    assign out = and_result;

endmodule
