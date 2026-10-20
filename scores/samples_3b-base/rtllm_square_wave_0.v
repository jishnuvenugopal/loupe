
module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    
    reg [7:0] count;

    
    always @(posedge clk) begin
        if (count == 0) begin
            count <= freq - 1;
            wave_out <= ~wave_out;
 
        end else begin
            count <= count - 1;
 
        end
    end

endmodule
