
module TopModule (
    input wire clk,
    input wire w,
    input wire R,
    input wire E,
    input wire L,
    output reg Q
);

    reg [7:0] reg_state;
    reg [7:0] prev_state;
    reg [7:0] value_to_load;
    reg load;
    reg enable;
    reg shift_counter;

    always @(posedge clk) begin
        if (enable) begin
            if (load) begin
                value_to_load <= w;
                load <= 0;
            end else if (R) begin
                value_to_load <= reg_state;
            end else if (L) begin
                value_to_load <= prev_state;
            end
        end

        if (E) begin
            shift_counter <= shift_counter + 1;
        end

        if (shift_counter == 8) begin
            Q <= value_to_load;
            shift_counter <= 0;
        end

        prev_state <= reg_state;
        reg_state <= value_to_load;
    end

endmodule
