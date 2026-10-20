
module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output reg   dout
);

    
    reg [1:0] cnt;

    
    reg [3:0] data;

    
    reg valid;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 2'b00;
        else
            cnt <= cnt + 2'b01;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data <= 4'b0000;
        else
            data <= {data[2:0], d[3]};
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            dout      <= 1'b0;
            valid     <= 1'b0;
        end else begin
            if (cnt == 2'd3) begin
                dout      <= data[3];
                valid_out <= 1'b1;
                valid     <= 1'b0;
                cnt       <= 2'd0;
            end else begin
                dout      <= 1'b0;
                valid_out <= 1'b0;
                valid     <= 1'b1;
                cnt       <= cnt + 2'd1;
            end
        end
    end

endmodule
