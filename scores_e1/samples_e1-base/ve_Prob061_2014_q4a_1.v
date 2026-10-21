
module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

    reg [7:0] shift_register;
    reg [7:0] counter;
    reg [7:0] load_value;

    always @(posedge clk) begin
        if (E) begin
            if (counter == 7) begin
                counter <= 0;
                load_value <= w;
            end else begin
                counter <= counter + 1;
                shift_register[counter] <= w;
            end
        end else if (R) begin
            counter <= 0;
            load_value <= w;
        end else if (L) begin
            counter <= counter + 1;
            shift_register[counter] <= load_value[counter];
        end
    end

    assign Q = shift_register[0];

endmodule
