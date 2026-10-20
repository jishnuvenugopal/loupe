
module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg timer_on;
    reg tc_reg;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            timer_on <= 1;
            tc_reg <= 0;
        end else if (timer_on && counter > 0) begin
            counter <= counter - 1;
        end

        if (counter == 0) begin
            timer_on <= 0;
            tc_reg <= 1;
        end
    end

    assign tc = tc_reg;

endmodule
