
module TopModule(clk, reset, d, q);
    input clk;
    input reset;
    input [7:0] d;
    output reg [7:0] q;

    generate
        genvar i;
        for (i = 0;
 i < 8;
 i = i + 1) begin : dff_gen
            DFF dff_inst (clk, reset, d[i], q[i]);
        end
    endgenerate

    
    module DFF(input clk, input reset, input d, output reg q);
        always @(posedge clk or posedge reset) begin
            if (reset)
                q <= 1'b0;
            else
                q <= d;
        end
    endmodule

endmodule
