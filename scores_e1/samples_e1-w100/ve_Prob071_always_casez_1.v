
module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    
    reg [2:0] lut [0:255];

    
    initial begin
        for (int i = 0;
 i <= 255;
 i++) begin
            
            reg [7:0] binary = i;
            reg [2:0] output = 3'b0;
            for (int j = 0;
 j < 8;
 j++) begin
                if (binary[j] == 1) begin
                    output = j;
                    break;
                end
            end
            lut[i] = output;
        end
    end

    
    assign pos = lut[in];

endmodule
