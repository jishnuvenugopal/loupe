
module TopModule (
    input  [7:0] in,  
    output reg [2:0] pos  
);

    reg [2:0] counter;
  

    always @(in) begin
        counter = 0;
  

        for (int i = 0;
 i < 8;
 i++) begin
            if (in[i] == 1) begin
                counter = i;
  
                break;
  
            end
        end

        pos = counter;
  
    end

endmodule
