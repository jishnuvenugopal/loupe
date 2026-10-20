
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_state;

    genvar i, j;
    generate
        for (i = 0;
 i < 16;
 i = i + 1) begin : gen_i
            for (j = 0;
 j < 16;
 j = j + 1) begin : gen_j
                
                localparam integer row_up = (i == 0) ? 15 : (i - 1);
                localparam integer row_down = (i == 15) ? 0 : (i + 1);
                localparam integer col_left = (j == 0) ? 15 : (j - 1);
                localparam integer col_right = (j == 15) ? 0 : (j + 1);

                
                localparam integer index_ul = row_up * 16 + col_left;
                localparam integer index_u  = row_up * 16 + j;
                localparam integer index_ur = row_up * 16 + col_right;
                localparam integer index_l  = i * 16 + col_left;
                localparam integer index_r  = i * 16 + col_right;
                localparam integer index_dl = row_down * 16 + col_left;
                localparam integer index_d  = row_down * 16 + j;
                localparam integer index_dr = row_down * 16 + col_right;

                
                wire [3:0] sum;
                assign sum = q[index_ul] + q[index_u] + q[index_ur] +
                             q[index_l] + q[index_r] + q[index_dl] +
                             q[index_d] + q[index_dr];

                
                assign next_state[i*16 + j] = (sum == 3) ? 1 :
                                               ((sum <= 1 || sum >= 4) ? 0 :
                                                q[i*16 + j]);
            end
        end
    endgenerate

    
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule
