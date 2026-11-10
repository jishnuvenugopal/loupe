
module TopModule (
    input  wire [3:0] in,
    output reg [1:0] pos
);

    reg [2:0] counter;

    always @(in) begin
        
        if (~in) begin
            counter = 3'b000;
        end else begin
            
            for (counter = 0;
 counter < 4;
 counter++) begin
                if (in[counter]) begin
                    pos = counter;
                    break;
                end
            end
        end
    end

endmodule
