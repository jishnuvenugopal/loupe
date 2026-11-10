
module TopModule (
    input wire [7:0] in,
    output reg [2:0] pos
);

    
    reg [2:0] lut [0:255] = {
        3'b000: 3'b000, 3'b001: 3'b001, 3'b010: 3'b010, 3'b011: 3'b011,
        3'b100: 3'b011, 3'b101: 3'b100, 3'b110: 3'b100, 3'b111: 3'b111
    };

    always @(*) begin
        
        for (int i = 0;
 i < 8;
 i++) begin
            
            if (in[i] == 1'b1) begin
                
                pos = i;
                break;
            end
        end
    end

endmodule
