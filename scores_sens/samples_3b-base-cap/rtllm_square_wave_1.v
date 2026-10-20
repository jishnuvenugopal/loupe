
module square_wave (
    input wire clk,
    input wire [7:0] freq,
    output reg wave_out
);

    
    reg [7:0] count;

    
    always @(posedge clk) begin
        if (freq != 8'h00) begin
            count <= 8'h00;
        end
    end

    
    always @(posedge clk) begin
        count <= count + 1'b1;
    end

    
    always @(posedge clk) begin
        if (count == freq - 1'b1) begin
            wave_out <= ~wave_out;
            count <= 8'h00;
        end
    end

endmodule
