
module TopModule (
    input clk,
    input reset,
    output shift_ena
);
    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset)
            counter <= 3'd4;
        else if (counter > 0)
            counter <= counter - 1;
    end

    assign shift_ena = (counter > 0);
endmodule
