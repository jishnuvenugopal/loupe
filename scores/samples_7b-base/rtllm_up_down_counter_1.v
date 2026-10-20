
module up_down_counter (
    input wire clk,          
    input wire reset,        
    input wire up_down,      
    output reg [15:0] count 
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 16'b0;
 
    end else begin
        if (up_down) begin
            if (count == 16'd65535) begin
                count <= 16'b0;
 
            end else begin
                count <= count + 1;
 
            end
        end else begin
            if (count == 16'd0) begin
                count <= 16'd65535;
 
            end else begin
                count <= count - 1;
 
            end
        end
    end
end

endmodule
