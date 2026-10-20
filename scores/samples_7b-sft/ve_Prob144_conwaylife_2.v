
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load)
        q_reg <= data;
    else
        q_reg <= next_q;
end

assign q = q_reg;

wire [255:0] next_q;

genvar r, c;
generate
for (r = 0;
 r < 16;
 r = r + 1) begin : row_loop
    for (c = 0;
 c < 16;
 c = c + 1) begin : col_loop
        wire [3:0] sum;
        assign sum = 
            q_reg[((r-1+16)%16)*16 + ((c-1+16)%16)] + 
            q_reg[((r-1+16)%16)*16 + c] +             
            q_reg[((r-1+16)%16)*16 + ((c+1)%16)] +    
            q_reg[r*16 + ((c-1+16)%16)] +             
            q_reg[r*16 + ((c+1)%16)] +                
            q_reg[((r+1)%16)*16 + ((c-1+16)%16)] +    
            q_reg[((r+1)%16)*16 + c] +                
            q_reg[((r+1)%16)*16 + ((c+1)%16)];
        

        wire current = q_reg[r*16 + c];
        assign next_q[r*16 + c] = (sum == 2) ? current :
                                  (sum == 3) ? 1'b1 :
                                  1'b0;
    end
end
endgenerate

endmodule
