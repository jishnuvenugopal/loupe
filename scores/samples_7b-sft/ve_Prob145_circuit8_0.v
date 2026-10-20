
module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state = 2'b00;

always @(posedge clock) begin
    case (state)
        2'b00: begin
            if (a) begin
                state <= 2'b01;
                p <= 0;
                q <= 0;
            end else begin
                state <= 2'b00;
                p <= 0;
                q <= 0;
            end
        end
        2'b01: begin
            if (a) begin
                state <= 2'b10;
                p <= 1;
                q <= 0;
            end else begin
                state <= 2'b00;
                p <= 0;
                q <= 0;
            end
        end
        2'b10: begin
            if (a) begin
                state <= 2'b01;
                p <= 0;
                q <= 0;
            end else begin
                state <= 2'b00;
                p <= 1;
                q <= 1;
            end
        end
        default: begin
            state <= 2'b00;
            p <= 0;
            q <= 0;
        end
    endcase
end

endmodule
