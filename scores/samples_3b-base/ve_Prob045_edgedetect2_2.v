
module TopModule (
    input wire clk,
    input wire [7:0] in,
    input wire [7:0] anyedge,
    output reg [7:0] out
);

    
    reg [7:0] prev_in;

    
    always @(posedge clk) begin
        
        prev_in <= in;

        
        for (int i = 0;
 i < 8;
 i++) begin
            if (anyedge[i]) begin
                if (in[i] == 1'b0 && prev_in[i] == 1'b1) begin
                    out[i] <= 1'b1;
                end else begin
                    out[i] <= prev_in[i];
                end
            end else begin
                out[i] <= prev_in[i];
            end
        end
    end

endmodule
