
module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg       valid_out,
    output reg       dout
);

    
    reg [1:0] cnt;

    
    reg [3:0] data;

    
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt    <= 2'b00;
            data   <= 4'b0000;
            valid_out <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                
                dout   <= data[3];
                valid_out <= 1'b1;
                cnt    <= 2'b00;
                data   <= d;
            end else begin
                
                dout   <= data[cnt];
                valid_out <= 1'b0;
                cnt    <= cnt + 2'b01;
                data   <= {data[2:0], data[3]};
            end
        end
    end

endmodule
