
module TopModule (
    input wire clk,
    input wire load,
    input wire [255:0] data,
    output reg [255:0] q
);

    
    reg [255:0] initial_q;
    initial begin
        initial_q = data;
        q = initial_q;
    end

    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            
            for (int i = 0;
 i < 256;
 i = i + 16) begin
                int alive_neighbors = 0;
                for (int j = 0;
 j < 16;
 j = j + 1) begin
                    int neighbor_index = i + j;
                    if (neighbor_index >= 256) begin
                        neighbor_index = neighbor_index - 256;
                    end
                    if (q[neighbor_index]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
                if (alive_neighbors == 0) begin
                    q[i] = 0;
                end else if (alive_neighbors == 1) begin
                    q[i] = 0;
                end else if (alive_neighbors == 2) begin
                    q[i] = q[i];
                end else if (alive_neighbors == 3) begin
                    q[i] = 1;
                end else if (alive_neighbors == 4) begin
                    q[i] = 0;
                end
            end
        end
    end

endmodule
