
module TopModule (
    input  wire [99:0] in,
    output reg  [99:0] out_both,
    output reg  [99:0] out_any,
    output reg  [99:0] out_different
);

    integer i;

    
    
    for (i = 0;
 i < 100;
 i = i + 1) begin : out_both_gen
        assign out_both[i] = (i == 99) ? 1'b0 : (in[i] & in[i+1]);
    end

    
    
    for (i = 0;
 i < 100;
 i = i + 1) begin : out_any_gen
        assign out_any[i] = (i == 0) ? 1'b0 : (in[i] | in[i-1]);
    end

    
    
    for (i = 0;
 i < 100;
 i = i + 1) begin : out_different_gen
        assign out_different[i] = (i == 99) ? (in[i] ^ in[0]) : (in[i] ^ in[i-1]);
    end

endmodule
