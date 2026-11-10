
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    parameter WIDTH = 8;
 

    reg [WIDTH-1:0] state;
    reg [WIDTH-1:0] count;
    reg [WIDTH-1:0] input_bits;
    reg [WIDTH-1:0] output_bits;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
            count <= 0;
            input_bits <= 0;
            output_bits <= 0;
        end else begin
            count <= count + 1;
            input_bits <= input_bits << 1 | x;
            if (count == WIDTH) begin
                state <= state ^ 1;
                output_bits <= ~input_bits;
                count <= 0;
            end
        end
    end

    assign z = output_bits;

endmodule
