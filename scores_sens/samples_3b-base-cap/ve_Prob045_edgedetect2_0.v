
module TopModule (
    input wire clk,
    input wire [7:0] in,
    output reg [7:0] anyedge
);

    
    reg [7:0] prev_in;

    
    always @(posedge clk) begin
        
        prev_in <= in;

        
        anyedge <= 8'b0;

        
        for (int i = 0;
 i < 8;
 i++) begin
            if (in[i] == 1'b0 && prev_in[i] == 1'b1) begin
                anyedge[i] <= 1'b1;
            end
        end
    end

endmodule
