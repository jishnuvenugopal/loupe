
module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

    reg [7:0] current_value;
    reg [7:0] previous_value;
    reg load;
    reg load_assertion;

    always @(posedge clk) begin
        if (E) begin
            load = 1'b1;
            load_assertion = 1'b1;
        end else begin
            load = 1'b0;
            load_assertion = 1'b0;
        end

        if (R) begin
            previous_value <= current_value;
            current_value <= w;
        end else begin
            previous_value <= current_value;
            current_value <= previous_value;
        end

        if (load) begin
            current_value <= w;
        end

        if (load_assertion) begin
            current_value <= w;
        end

        Q <= current_value;
    end

endmodule
