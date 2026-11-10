
module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] prev_state;

    always @(posedge clk) begin
        
        if (in == 8'b00000000 && prev_state == 8'b11111111) begin
            
            pedge = 8'b1;
        end else begin
            
            prev_state = in;
            
            pedge = 8'b0;
        end
    end

endmodule
