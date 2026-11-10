
module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] current_state;
    reg [31:0] next_state;
    reg [31:0] change_count;
    reg [31:0] reset_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= 32'b0;
            next_state <= 32'b0;
            change_count <= 0;
            reset_counter <= 0;
        end else begin
            current_state <= next_state;
            next_state <= in;
            change_count <= change_count + 1'b1;
            reset_counter <= reset_counter + 1'b1;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 32'b0;
        end else begin
            if (current_state != next_state) begin
                out <= 32'b1;
            end else begin
                out <= 32'b0;
            end
        end
    end

endmodule
