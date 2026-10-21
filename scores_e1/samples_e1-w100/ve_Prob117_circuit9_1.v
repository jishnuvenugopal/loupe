
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    reg [1:0] state;

    always @(posedge clk) begin
        case (state)
            2'b00: begin
                state <= 2'b01;
                q <= 3'b001;
            end
            2'b01: begin
                state <= 2'b00;
                q <= 3'b010;
            end
            default: begin
                state <= 2'b00;
                q <= 3'b001;
            end
        endcase
    end

endmodule
