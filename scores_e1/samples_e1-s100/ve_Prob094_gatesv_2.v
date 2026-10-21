
module TopModule (
    input wire [3:0] in,
    output reg [3:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

    reg [3:0] current_input;
    reg [3:0] previous_input;
    reg [3:0] current_output;
    reg [3:0] previous_output;

    always @(posedge clk or negedge rst) begin
        if (rst) begin
            current_input <= 4'b0000;
            previous_input <= 4'b0000;
            current_output <= 4'b0000;
            previous_output <= 4'b0000;
        end else begin
            current_input <= in;
            previous_input <= current_input;

            current_output[0] <= (current_input[0] == previous_input[1]) & (current_input[1] == previous_input[2]) & (current_input[2] == previous_input[3]);
            current_output[1] <= (current_input[1] == previous_input[2]) & (current_input[2] == previous_input[3]) & (current_input[3] == previous_input[0]);
            current_output[2] <= (current_input[2] == previous_input[3]) & (current_input[3] == previous_input[0]) & (current_input[0] == previous_input[1]);
            current_output[3] <= (current_input[3] == previous_input[0]) & (current_input[0] == previous_input[1]) & (current_input[1] == previous_input[2]);

            previous_output <= current_output;
        end
    end

endmodule
