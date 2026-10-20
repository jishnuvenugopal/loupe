
module TopModule (input [7:0] in, output reg [2:0] pos);

always @(*) begin
    pos = 3'b000;
 
    for (reg [2:0] i = 3'b000;
 i < 3'b1000;
 i = i + 1) begin
        if (in[i] == 1'b1) begin
            pos = i;
 
            break;
 
        end
    end
end

endmodule
