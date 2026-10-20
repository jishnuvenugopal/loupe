
module parallel2serial(
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg [3:0] dout
);

    
    reg [1:0] cnt;

    
    reg [3:0] data;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
            cnt <= 2'b00;
            data <= 4'b0000;
            valid_out <= 0;
        end else begin
            
            if (cnt == 2'b00) begin
                data <= d;
            end

            
            if (cnt == 2'b00) begin
                dout <= data[3];
                valid_out <= 1;
            end

            
            if (cnt < 2'b11) begin
                data <= {data[2:0], data[3]};
                cnt <= cnt + 1;
                valid_out <= 0;
            end
        end
    end

endmodule
