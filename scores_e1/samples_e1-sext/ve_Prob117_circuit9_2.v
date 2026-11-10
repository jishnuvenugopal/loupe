
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    reg [1:0] state;

    always @(posedge clk) begin
        case (state)
            2'b00: begin
                if (a == 0) begin
                    state <= 2'b01;
                    q <= 3'b111;
                end else begin
                    state <= 2'b00;
                    q <= 3'b000;
                end
            end
            2'b01: begin
                state <= 2'b00;
                q <= 3'b000;
            end
            default: begin
                state <= 2'b00;
                q <= 3'b000;
            end
        endcase
    end

endmodule
