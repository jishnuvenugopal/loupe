
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] reg_state;
    reg [1:0] counter;

    always @(posedge clk or posedge load or posedge ena) begin
        if (load) begin
            reg_state = data;
        end else if (ena[1]) begin
            counter <= counter + 1;
            if (counter == 100) begin
                counter <= 0;
            end
        end else if (ena[0]) begin
            counter <= counter - 1;
            if (counter == 0) begin
                counter <= 100;
            end
        end
        q <= reg_state;
    end

endmodule
