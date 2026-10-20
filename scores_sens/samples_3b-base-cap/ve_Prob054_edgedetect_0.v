
module TopModule (
    input  clk,
    input  [7:0] in,
    output [7:0] pedge
);

    
    reg [7:0] prev_in;

    
    always @(posedge clk) begin
        
        prev_in <= in;

        
        pedge <= {8{in[7] & ~prev_in[7]}};
 
        pedge <= {pedge[6:0], in[6] & ~prev_in[6]};
 
        pedge <= {pedge[5:0], in[5] & ~prev_in[5]};
 
        pedge <= {pedge[4:0], in[4] & ~prev_in[4]};
 
        pedge <= {pedge[3:0], in[3] & ~prev_in[3]};
 
        pedge <= {pedge[2:0], in[2] & ~prev_in[2]};
 
        pedge <= {pedge[1:0], in[1] & ~prev_in[1]};
 
        pedge <= {pedge[0], in[0] & ~prev_in[0]};
 
    end

endmodule
