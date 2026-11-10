
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
                    q <= 4'b0001;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin
                if (a == 0) begin
                    state <= 2'b00;
                    q <= 4'b0010;
                end else begin
                    state <= 2'b01;
                end
            end
        endcase
    end

endmodule
