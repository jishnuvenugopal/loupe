
module multi_16bit (
    input wire clk,          
    input wire rst_n,        
    input wire start,        
    input wire [15:0] ain,   
    input wire [15:0] bin,   
    output reg [31:0] yout,  
    output reg done          
);

reg [4:0] i;
              
reg [15:0] areg;
          
reg [15:0] breg;
          
reg [31:0] yout_r;
        
reg done_r;
               

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'b00000;
        areg <= 16'b0;
        breg <= 16'b0;
        yout_r <= 32'b0;
        done_r <= 1'b0;
    end else begin
        if (start) begin
            if (i == 5'b00000) begin
                areg <= ain;
                breg <= bin;
            end
            if (i < 5'b10001) begin
                if (areg[i] == 1'b1) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                i <= i + 1;
            end else begin
                i <= 5'b00000;
            end
        end else begin
            i <= 5'b00000;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done <= 1'b0;
    end else begin
        if (i == 5'b00010) begin
            done <= 1'b1;
        end else if (i == 5'b10001) begin
            done <= 1'b0;
        end
    end
end

assign yout = yout_r;

endmodule
