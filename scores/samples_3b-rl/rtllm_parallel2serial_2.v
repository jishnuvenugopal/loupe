
module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    
    reg [1:0] cnt;

    
    reg [3:0] data;

    always @(posedge clk) begin
        if (rst_n) begin
            cnt   <= 2'b00;
            data  <= 4'b0000;
            valid_out <= 1'b0;
        end else begin
            
            dout <= data[3];

            
            if (cnt == 2'b11) begin
                data <= d;
                cnt  <= 2'b00;
                valid_out <= 1'b1;
            end
            
            else begin
                cnt <= cnt + 2'b01;
                valid_out <= 1'b0;
            end
        end
    end

endmodule
