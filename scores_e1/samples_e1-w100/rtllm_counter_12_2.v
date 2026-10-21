
module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

    
    reg [3:0] count;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1'b1;
        end
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out <= 4'b0000;
        end else if (valid_count) begin
            if (count == 4'd11) begin
                out <= 4'b0000;
            end else begin
                out <= count;
            end
        end
    end

endmodule
