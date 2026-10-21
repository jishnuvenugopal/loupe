
module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

    reg [1:0] state;

    always @(posedge clk) begin
        case (state)
            2'b00: begin
                if (a == 1) begin
                    state <= 2'b01;
                    q <= 4'b0100;
                end else begin
                    state <= 2'b00;
                    q <= 4'b0000;
                end
            end
            2'b01: begin
                if (a == 1) begin
                    state <= 2'b10;
                    q <= 4'b0101;
                end else begin
                    state <= 2'b01;
                    q <= 4'b0100;
                end
            end
            2'b10: begin
                if (a == 1) begin
                    state <= 2'b11;
                    q <= 4'b0110;
                end else begin
                    state <= 2'b10;
                    q <= 4'b0101;
                end
            end
            2'b11: begin
                state <= 2'b00;
                q <= 4'b0000;
            end
        endcase
    end

endmodule
