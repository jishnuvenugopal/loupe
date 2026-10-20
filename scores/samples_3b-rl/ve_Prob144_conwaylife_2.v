
module TopModule (
    input        clk,
    input        load,
    input [255:0] data,
    output reg [255:0] q
);

    
    

    
    
    
    
    
    

    
    integer neighbor_offsets [7];
    initial begin
        neighbor_offsets[0] = 15;
    
        neighbor_offsets[1] = 16;
    
        neighbor_offsets[2] = 17;
    
        neighbor_offsets[3] = 1;
     
        neighbor_offsets[4] = 0;
     
        neighbor_offsets[5] = 18;
    
        neighbor_offsets[6] = 19;
    
        neighbor_offsets[7] = 20;
    
    end

    
    reg [3:0] neighbor_count [255];

    
    reg [255:0] next_q;

    
    always @(posedge clk) begin
        if (load)
            q <= data;
    end

    
    always @(*) begin
        for (integer i = 0;
 i < 256;
 i = i + 1) begin
            neighbor_count[i] = 0;
            for (integer n = 0;
 n < 8;
 n = n + 1) begin
                integer neighbor = i + neighbor_offsets[n];
                neighbor_count[i] = neighbor_count[i] + q[neighbor];
            end
        end
    end

    
    always @(*) begin
        for (integer i = 0;
 i < 256;
 i = i + 1) begin
            if (q[i] == 1) begin
                if (neighbor_count[i] == 0 || neighbor_count[i] == 1)
                    next_q[i] = 0;
                else if (neighbor_count[i] == 3)
                    next_q[i] = 1;
                else
                    next_q[i] = 0;
            end else begin
                if (neighbor_count[i] == 3)
                    next_q[i] = 1;
                else
                    next_q[i] = 0;
            end
        end
    end

    
    always @(posedge clk) begin
        q <= next_q;
    end

endmodule
