
module TopModule (
    input        clk,
    input        load,
    input [255:0] data,
    output reg [255:0] q
);

    
    reg [255:0] next_q;
    reg [15:0] neighbor_count;
    reg [15:0] current_row;
    reg [15:0] next_row;

    
    reg reset;

    
    

    
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end
    end

    
    always @(posedge clk) begin
        
        if (reset) begin
            q <= 256'b0;
        end else begin
            
            next_q = 256'b0;
            for (integer i = 0;
 i < 16;
 i = i + 1) begin
                for (integer j = 0;
 j < 16;
 j = j + 1) begin
                    
                    current_row = q[15 + 16*i : 16*i];
                    neighbor_count = 0;
                    
                    if (i > 0) neighbor_count = neighbor_count + current_row[15];
                    if (i > 0 && j > 0) neighbor_count = neighbor_count + current_row[14];
                    if (j > 0) neighbor_count = neighbor_count + current_row[0];
                    if (i < 15) neighbor_count = neighbor_count + current_row[1];
                    if (i < 15 && j > 0) neighbor_count = neighbor_count + current_row[16];
                    if (i < 15) neighbor_count = neighbor_count + current_row[17];
                    if (i > 0 && j < 15) neighbor_count = neighbor_count + current_row[15 - 16];
                    if (j < 15) neighbor_count = neighbor_count + current_row[16 - 16];
                    
                    case (current_row[j])
                        2'b00: next_q[15 + 16*i + j] = (neighbor_count == 3) ? 1'b1 : 1'b0;
                        2'b01: next_q[15 + 16*i + j] = (neighbor_count == 2 || neighbor_count == 3) ? 1'b1 : 1'b0;
                        2'b10: next_q[15 + 16*i + j] = (neighbor_count == 2 || neighbor_count == 3) ? 1'b1 : 1'b0;
                        2'b11: next_q[15 + 16*i + j] = (neighbor_count == 3 || neighbor_count == 2) ? 1'b1 : 1'b0;
                        default: next_q[15 + 16*i + j] = 1'b0;
                    endcase
                end
            end
            q <= next_q;
        end
    end

endmodule
