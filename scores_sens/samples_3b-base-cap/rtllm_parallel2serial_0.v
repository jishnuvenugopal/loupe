
module parallel2serial(
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg [3:0] dout
);

    
    reg [3:0] cnt;

    
    reg [3:0] data;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
            cnt <= 4'b0000;
            data <= 4'b0000;
            valid_out <= 0;
        end else begin
            
            data <= d;

            
            if (cnt == 3) begin
                
                valid_out <= 1;
                cnt <= 4'b0000;
            end else begin
                
                cnt <= cnt + 1;
                valid_out <= 0;
            end

            
            dout <= data[3:0];
        end
    end

endmodule
