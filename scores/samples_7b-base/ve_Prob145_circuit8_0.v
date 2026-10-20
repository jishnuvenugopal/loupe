
module TopModule (
    input  clock,
    input  a,
    output reg p,
    output reg q
);

    reg [1:0] state;

    parameter state_0 = 2'b00,
              state_1 = 2'b01,
              state_2 = 2'b10,
              state_3 = 2'b11;

always @(posedge clock) begin
    case (state)
        state_0: begin
            if (a) begin
                state <= state_1;
                p <= 0;
                q <= 0;
            end else begin
                state <= state_0;
                p <= 0;
                q <= 0;
            end
        end
        state_1: begin
            if (a) begin
                state <= state_2;
                p <= 0;
                q <= 0;
            end else begin
                state <= state_1;
                p <= 0;
                q <= 0;
            end
        end
        state_2: begin
            if (a) begin
                state <= state_3;
                p <= 0;
                q <= 1;
            end else begin
                state <= state_2;
                p <= 0;
                q <= 1;
            end
        end
        state_3: begin
            if (a) begin
                state <= state_1;
                p <= 1;
                q <= 1;
            end else begin
                state <= state_3;
                p <= 1;
                q <= 1;
            end
        end
    endcase
end

endmodule
