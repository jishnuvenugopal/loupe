
module TopModule (clk, in, out);
    input clk;
    input in;
    output out;

    wire xor_out;
  

    
    reg out_ff;
  

    always @(posedge clk) begin
        out_ff <= xor_out;
  
    end

    
    assign xor_out = in ^ out_ff;
  
endmodule
