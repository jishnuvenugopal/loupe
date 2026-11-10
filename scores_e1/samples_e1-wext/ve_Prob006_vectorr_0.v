

interface TopModuleInterface (
    input wire [7:0] in,
    output reg [7:0] out
);

endinterface


module TopModule (
    input TopModuleInterface in_out
);

    
    assign in_out.out = ~in_out.in;

endmodule
