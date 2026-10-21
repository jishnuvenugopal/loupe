
module TopModule (
    input clk,
    input load,
    output reg [255:0] q
);

    
    reg [15:0] init_state [0:15];

    
    always @(posedge clk) begin
        if (load) begin
            init_state <= {256{1'b0}};
            for (int i = 0;
 i < 16;
 i++) begin
                init_state[i] <= {16{rand() % 2}};
            end
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 16;
 i++) begin
            for (int j = 0;
 j < 16;
 j++) begin
                int count = 0;
                for (int di = -1;
 di <= 1;
 di++) begin
                    for (int dj = -1;
 dj <= 1;
 dj++) begin
                        if (di == 0 && dj == 0) continue;
                        int ni = (i + di + 16) % 16;
                        int nj = (j + dj + 16) % 16;
                        count += q[ni][nj];
                    end
                end
                if (count == 0) begin
                    q[i][j] <= 1'b0;
                end else if (count == 1) begin
                    q[i][j] <= 1'b0;
                end else if (count == 2) begin
                    q[i][j] <= q[i][j];
                end else if (count == 3) begin
                    q[i][j] <= 1'b1;
                end else if (count == 4) begin
                    q[i][j] <= 1'b0;
                end
            end
        end
    end

endmodule
