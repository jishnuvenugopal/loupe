
module ring_counter(
    input wire clk,          
    input wire reset,        
    output reg [7:0] out    
);

reg [2:0] counter;
  

always @(posedge clk or posedge reset) begin
    if (reset) begin
        
        counter <= 3'b000;
    end else begin
        
        counter <= counter + 1;
        
        
        if (counter == 3'b111) begin
            counter <= 3'b000;
        end
    end
end


always @(*) begin
    out = 8'b0;
    case (counter)
        3'b000: out[0] = 1'b1;
        3'b001: out[1] = 1'b1;
        3'b010: out[2] = 1'b1;
        3'b011: out[3] = 1'b1;
        3'b100: out[4] = 1'b1;
        3'b101: out[5] = 1'b1;
        3'b110: out[6] = 1'b1;
        3'b111: out[7] = 1'b1;
    endcase
end

endmodule
