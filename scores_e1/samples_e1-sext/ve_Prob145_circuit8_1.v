
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
                if (a == 0) begin
                    p <= p;
                    q <= q;
                end else begin
                    p <= q;
                    q <= p;
                end
            end
            2'b01: begin
                if (a == 0) begin
                    p <= p;
                    q <= q;
                end else begin
                    p <= q;
                    q <= p;
                end
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end

endmodule
