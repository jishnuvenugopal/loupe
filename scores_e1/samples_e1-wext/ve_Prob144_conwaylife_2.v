
module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    
    reg [15:0] q[15:0];

    
    reg [15:0] state[15:0];

    
    reg [15:0] counts[15:0];

    
    reg [15:0] changes[15:0];

    
    reg [15:0] transitions[15:0];

    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
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
                if (q[i][j] == 1) begin
                    count += 1;
                    if (i > 0) count += q[i-1][j];
                    if (i < 15) count += q[i+1][j];
                    if (j > 0) count += q[i][j-1];
                    if (j < 15) count += q[i][j+1];
                end
                state[i][j] = count;
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
                if (state[i][j] == 0) begin
                    changes[i][j] = 1;
                end
                if (state[i][j] == 1) begin
                    changes[i][j] = 0;
                end
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
                if (changes[i][j] == 1) begin
                    transitions[i][j] = 1;
                end
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
                if (transitions[i][j] == 1) begin
                    q[i][j] = !q[i][j];
                end
            end
        end
    end

endmodule
