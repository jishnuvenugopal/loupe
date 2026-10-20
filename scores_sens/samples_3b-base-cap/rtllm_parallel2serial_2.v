
module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg [3:0] dout
);

    
    reg [2:0] cnt;

    
    reg [3:0] data;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
            cnt <= 3'b000;
            data <= 4'b0000;
            valid_out <= 0;
        end else begin
            
            if (cnt == 3'b111) begin
                dout <= data[3];
                cnt <= 3'b000;
                valid_out <= 1;
            end else begin
                
                data <= {data[2:0], d[3]};
                cnt <= cnt + 1'b1;
                valid_out <= 0;
            end
        end
    end

endmodule
