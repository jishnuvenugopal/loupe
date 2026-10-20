
module parallel2serial (
    input        clk,
    input        rst_n,
    input [3:0]  d,
    output reg   valid_out,
    output reg   dout
);

    
    reg [3:0] data;
    reg [1:0] cnt;

    always @(posedge clk) begin
        if (rst_n) begin
            data <= 4'b0;
            cnt  <= 2'b0;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                
                dout <= data[1];
                data <= d;
                cnt <= 2'd0;
                valid_out <= 1'b1;
            end else begin
                
                data <= {data[0], data[1:3]};
                cnt <= cnt + 2'd1;
                valid_out <= 1'b0;
            end
        end
    end

endmodule
