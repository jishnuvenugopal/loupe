
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    
    reg [31:0] flipFlop;
    reg [31:0] counter;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            flipFlop <= 32'b0;
            counter <= 32'b0;
        end else begin
            if (flipFlop != in) begin
                flipFlop <= in;
                counter <= counter + 1'b1;
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            flipFlop <= 32'b0;
            counter <= 32'b0;
        end else begin
            if (flipFlop == in) begin
                flipFlop <= in;
                counter <= 32'b0;
            end
        end
    end

    
    assign out = flipFlop;

endmodule
