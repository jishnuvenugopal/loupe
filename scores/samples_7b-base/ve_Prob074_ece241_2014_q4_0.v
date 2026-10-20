
module TopModule(clk, x, z);
    input clk, x;
    output z;

    reg dff_out1, dff_out2, dff_out3;
    reg [1:0] temp_out;

    
    wire xor_out = x ^ dff_out1;

    
    wire and_out = x & ~dff_out2;

    
    wire or_out = x | ~dff_out3;

    
    always @(posedge clk) begin
        dff_out1 <= xor_out;
        dff_out2 <= and_out;
        dff_out3 <= or_out;
    end

    
    assign z = dff_out1 & dff_out2 & dff_out3;
endmodule
