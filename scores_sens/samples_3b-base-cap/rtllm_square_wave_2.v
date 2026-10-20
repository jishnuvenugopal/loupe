
module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    
    reg [7:0] count;

    
    always @(posedge clk) begin
        if (count == 0) begin
            wave_out <= ~wave_out;
 
        end
        count <= count + 1;
 
        if (count == freq - 1) begin
            count <= 0;
 
        end
    end

endmodule
