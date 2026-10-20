
module TopModule (
    input  clk,
    input  [7:0] d,
    output [7:0] q
);

    
    localparam NUM_DFFS = 8;

    
    reg [7:0] dff[NUM_DFFS];

    
    reg rst = 0;

    
    generate
        for (genvar i = 0;
 i < NUM_DFFS;
 i = i + 1) begin
            
            dff[i] (
                .d_i(d[i]),  
                .clk_i(clk),  
                .rst_i(rst),  
                .q_o(q[i])   
            );
        end
    endgenerate

endmodule
