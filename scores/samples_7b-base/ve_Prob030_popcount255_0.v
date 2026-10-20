
module TopModule(input [254:0] in, output reg [7:0] out);

    wire [254:0] count_reg;

    
    always @(*) begin
        count_reg = 0;
        for (int i = 0;
 i < 255;
 i = i + 1) begin
            count_reg = count_reg + in[i];
        end
    end

    
    assign out = count_reg;

endmodule
