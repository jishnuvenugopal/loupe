
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] reg_state;
    reg [1:0] counter;

    always @(posedge clk) begin
        if (load) begin
            reg_state = data;
            counter = 0;
        end else begin
            if (ena == 2'b01) begin
                reg_state = {reg_state[99], reg_state[98:0]};
                counter <= counter + 1;
            end else if (ena == 2'b10) begin
                reg_state = {reg_state[0], reg_state[1:99]};
                counter <= counter + 1;
            end else if (ena == 2'b00 || ena == 2'b11) begin
                counter <= counter;
            end
        end
    end

    assign q = reg_state;

endmodule
