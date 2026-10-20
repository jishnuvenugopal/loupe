
module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q = 0
);

    reg [255:0] next_q;

    generate
        genvar r, c;
        for (r = 0;
 r < 16;
 r = r + 1) begin : row_gen
            for (c = 0;
 c < 16;
 c = c + 1) begin : col_gen
                
                wire [3:0] sum;

                
                wire N1, N2, N3, N4, N5, N6, N7, N8;

                
                assign N1 = q[(((r - 1 + 16) % 16) * 16) + ((c - 1 + 16) % 16)];
                
                assign N2 = q[(((r - 1 + 16) % 16) * 16) + (c)];
                
                assign N3 = q[(((r - 1 + 16) % 16) * 16) + ((c + 1) % 16)];
                
                assign N4 = q[(r * 16) + ((c - 1 + 16) % 16)];
                
                assign N5 = q[(r * 16) + ((c + 1) % 16)];
                
                assign N6 = q[(((r + 1) % 16) * 16) + ((c - 1 + 16) % 16)];
                
                assign N7 = q[(((r + 1) % 16) * 16) + (c)];
                
                assign N8 = q[(((r + 1) % 16) * 16) + ((c + 1) % 16)];

                assign sum = N1 + N2 + N3 + N4 + N5 + N6 + N7 + N8;

                
                always @(*) begin
                    if (sum < 2 || sum > 3)
                        next_q[r * 16 + c] = 1'b0;
                    else if (sum == 3)
                        next_q[r * 16 + c] = 1'b1;
                    else
                        next_q[r * 16 + c] = q[r * 16 + c];
                end
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule
