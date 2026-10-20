
module TopModule (
    input wire clk,
    input wire reset,
    output reg [3:0] ena,
    output reg [15:0] q
);

    
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 4'b0000;
            tens <= 4'b0000;
            hundreds <= 4'b0000;
            thousands <= 4'b0000;
            q <= 16'b0000000000000000;
        end else begin
            ones <= ones + 1'b1;
            if (ones == 4'b1000) begin
                ones <= 4'b0000;
                tens <= tens + 1'b1;
                if (tens == 4'b1000) begin
                    tens <= 4'b0000;
                    hundreds <= hundreds + 1'b1;
                    if (hundreds == 4'b1000) begin
                        hundreds <= 4'b0000;
                        thousands <= thousands + 1'b1;
                    end
                end
            end
            q <= {thousands, hundreds, tens, ones};
        end
    end

    
    assign ena[3] = ones == 4'b1000;
    assign ena[2] = tens == 4'b1000;
    assign ena[1] = hundreds == 4'b1000;
    assign ena[0] = thousands == 4'b1000;

endmodule
