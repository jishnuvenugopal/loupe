
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
                    p <= 0;
                    q <= 0;
                end else begin
                    p <= 0;
                    q <= 1;
                end
            end
            2'b01: begin
                if (a == 0) begin
                    p <= 1;
                    q <= 1;
                end else begin
                    p <= 1;
                    q <= 0;
                end
            end
            default: state <= 2'b00;
        endcase
    end

endmodule
