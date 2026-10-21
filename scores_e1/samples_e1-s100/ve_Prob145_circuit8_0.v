
module TopModule (
    input wire clock,
    input wire a,
    output reg p,
    output reg q
);

    reg [1:0] state;

    always @(posedge clock) begin
        case (state)
            2'b00: begin
                p <= 0;
                q <= 0;
                state <= 2'b01;
            end
            2'b01: begin
                p <= 0;
                q <= 1;
                state <= 2'b10;
            end
            2'b10: begin
                p <= 0;
                q <= 1;
                state <= 2'b00;
            end
            2'b11: begin
                p <= 0;
                q <= 0;
                state <= 2'b00;
            end
        endcase
    end

    always @(posedge a) begin
        case (a)
            1'b0: begin
                state <= 2'b00;
            end
            1'b1: begin
                state <= 2'b01;
            end
        endcase
    end

endmodule
