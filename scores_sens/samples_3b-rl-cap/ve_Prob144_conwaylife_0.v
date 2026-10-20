
module TopModule (
    input        clk,
    input        load,
    input [255:0] data,
    output reg [255:0] q
);

    
    reg [7:0] neighbour_count [0:255];

    
    reg [255:0] next_q;

    
    reg reset;

    
    always @(posedge clk) begin
        if (load) begin
            reset <= 1'b0;
        end else begin
            reset <= 1'b1;
        end
    end

    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            q <= 256'b0;
        end else begin
            q <= next_q;
        end
    end

    
    
    
    always @(*) begin
        for (integer i = 0;
 i < 16;
 i = i + 1) begin
            for (integer j = 0;
 j < 16;
 j = j + 1) begin
                neighbour_count[i * 16 + j] = 0;
                
                if (i == 0) begin
                    neighbour_count[i * 16 + j] = neighbour_count[15 * 16 + j] + neighbour_count[16 * 16 + j] + neighbour_count[17 * 16 + j] + neighbour_count[18 * 16 + j] + neighbour_count[19 * 16 + j] + neighbour_count[20 * 16 + j] + neighbour_count[21 * 16 + j] + neighbour_count[22 * 16 + j];
                end
                
                else if (i == 15) begin
                    neighbour_count[i * 16 + j] = neighbour_count[0 * 16 + j] + neighbour_count[1 * 16 + j] + neighbour_count[2 * 16 + j] + neighbour_count[3 * 16 + j] + neighbour_count[4 * 16 + j] + neighbour_count[5 * 16 + j] + neighbour_count[6 * 16 + j] + neighbour_count[7 * 16 + j];
                end
                
                else if (j == 0) begin
                    neighbour_count[i * 16 + j] = neighbour_count[i * 16 + 15] + neighbour_count[i * 16 + 16] + neighbour_count[i * 16 + 17] + neighbour_count[i * 16 + 18] + neighbour_count[i * 16 + 19] + neighbour_count[i * 16 + 20] + neighbour_count[i * 16 + 21] + neighbour_count[i * 16 + 22];
                end
                
                else if (j == 15) begin
                    neighbour_count[i * 16 + j] = neighbour_count[i * 16 + 0] + neighbour_count[i * 16 + 1] + neighbour_count[i * 16 + 2] + neighbour_count[i * 16 + 3] + neighbour_count[i * 16 + 4] + neighbour_count[i * 16 + 5] + neighbour_count[i * 16 + 6] + neighbour_count[i * 16 + 7];
                end
                
                else begin
                    neighbour_count[i * 16 + j] = neighbour_count[i * 16 + j - 1] + neighbour_count[i * 16 + j + 1] + neighbour_count[(i - 1) * 16 + j] + neighbour_count[(i + 1) * 16 + j] + neighbour_count[(i - 1) * 16 + j - 1] + neighbour_count[(i - 1) * 16 + j + 1] + neighbour_count[(i + 1) * 16 + j - 1] + neighbour_count[(i + 1) * 16 + j + 1];
                end
            end
        end
    end

    
    always @(*) begin
        for (integer i = 0;
 i < 16;
 i = i + 1) begin
            for (integer j = 0;
 j < 16;
 j = j + 1) begin
                case (neighbour_count[i * 16 + j])
                    0, 1: next_q[i * 16 + j] = 1'b0;
                    2: next_q[i * 16 + j] = q[i * 16 + j];
                    3: next_q[i * 16 + j] = 1'b1;
                    default: next_q[i * 16 + j] = 1'b0;
                endcase
            end
        end
    end

endmodule
