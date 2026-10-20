
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

    reg [255:0] q_reg;
    reg [255:0] next_q;

    assign q = q_reg;

    genvar i, j;

    generate
        for (i = 0;
 i < 16;
 i = i + 1) begin : gen_row
            for (j = 0;
 j < 16;
 j = j + 1) begin : gen_col
                
                wire [3:0] sum;

                
                wire neighbor_tl = q_reg[ (((i-1+16)%16)*16 + ((j-1+16)%16)) ];
                
                wire neighbor_t = q_reg[ (((i-1+16)%16)*16 + j) ];
                
                wire neighbor_tr = q_reg[ (((i-1+16)%16)*16 + ((j+1)%16)) ];
                
                wire neighbor_l = q_reg[ (i * 16 + ((j-1+16)%16)) ];
                
                wire neighbor_r = q_reg[ (i * 16 + ((j+1)%16)) ];
                
                wire neighbor_bl = q_reg[ (((i+1)%16)*16 + ((j-1+16)%16)) ];
                
                wire neighbor_b = q_reg[ (((i+1)%16)*16 + j) ];
                
                wire neighbor_br = q_reg[ (((i+1)%16)*16 + ((j+1)%16)) ];

                
                assign sum = neighbor_tl + neighbor_t + neighbor_tr + neighbor_l 
                            + neighbor_r + neighbor_bl + neighbor_b + neighbor_br;

                
                assign next_q[i*16 + j] = (sum == 3) ? 1'b1 :
                                        ((sum > 2 && sum < 4) ? q_reg[i*16 + j] : 1'b0);
            end
        end
    endgenerate

    
    always @(posedge clk) begin
        if (load)
            q_reg <= data;
        else
            q_reg <= next_q;
    end

endmodule
