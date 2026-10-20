
module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 3;
            shift_ena <= 1;
        end else begin
            if (count > 0) begin
                count <= count - 1;
                shift_ena <= 1;
            end else begin
                shift_ena <= 0;
            end
        end
    end

endmodule
