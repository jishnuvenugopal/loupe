
module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    
    wire and_result;
    and_result = in[0];
    for (genvar i = 1;
 i < 100;
 i++) begin
        and_result = and_result & in[i];
    end

    
    wire or_result;
    or_result = in[0];
    for (genvar i = 1;
 i < 100;
 i++) begin
        or_result = or_result | in[i];
    end

    
    wire xor_result;
    xor_result = in[0];
    for (genvar i = 1;
 i < 100;
 i++) begin
        xor_result = xor_result ^ in[i];
    end

    
    assign out_and = and_result;
    assign out_or  = or_result;
    assign out_xor = xor_result;

endmodule
