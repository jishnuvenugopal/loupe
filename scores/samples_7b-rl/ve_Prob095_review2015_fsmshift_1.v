
module TopModule (
    input clk,
    input reset,
    output reg shift_ena = 0
);

    reg [1:0] counter = 0;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            shift_ena <= 1'b1;
        end else begin
            if (shift_ena) begin
                if (counter == 2'd3) begin
                    shift_ena <= 0;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    end

endmodule
