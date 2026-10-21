
module TopModule (
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [7:0] s,
    output reg overflow
);

    
    reg [15:0] sum;
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            sum <= 16'b0;
            overflow <= 1'b0;
        end else begin
            sum <= a + b;
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            overflow <= 1'b0;
        end else begin
            if (sum[15] == 1'b1 && (a[7] == 1'b1 && b[7] == 1'b0) || (a[7] == 1'b0 && b[7] == 1'b1)) begin
                overflow <= 1'b1;
            end else begin
                overflow <= 1'b0;
            end
        end
    end

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            s <= 8'b0;
        end else begin
            s <= sum[7:0];
        end
    end

endmodule
