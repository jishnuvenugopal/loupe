
module TopModule (
    input wire clk,
    input wire load,
    input wire [255:0] data,
    output reg [255:0] q
);

    
    reg [255:0] initial_state;

    
    always @(posedge clk) begin
        if (load) begin
            initial_state = data;
            q <= initial_state;
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 256;
 i++) begin
            int x = i % 16;
            int y = i / 16;
            int count = 0;

            
            for (int dx = -1;
 dx <= 1;
 dx++) begin
                for (int dy = -1;
 dy <= 1;
 dy++) begin
                    if (dx == 0 && dy == 0) continue;
                    int nx = (x + dx + 16) % 16;
                    int ny = (y + dy + 16) % 16;
                    count += q[nx * 16 + ny];
                end
            end

            
            if (count == 0) begin
                q[i] = 0;
            end else if (count == 1) begin
                q[i] = 0;
            end else if (count == 2) begin
                q[i] = q[i];
            end else if (count == 3) begin
                q[i] = 1;
            end else if (count == 4) begin
                q[i] = 0;
            end
        end
    end

endmodule
