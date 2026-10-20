
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);


localparam STATE_A = 3'b000,
           STATE_B = 3'b001,
           STATE_C = 3'b010,
           STATE_D = 3'b011;

reg [1:0] state, next_state;


always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    next_state = state;
    g = 3'b000;

    case (state)
        STATE_A: begin
            if (r == 3'b000) begin
                next_state = STATE_A;
            end else if (r == 3'b001) begin
                next_state = STATE_B;
                g[0] = 1;
            end else if (r == 3'b010) begin
                next_state = STATE_C;
                g[1] = 1;
            end else if (r == 3'b100) begin
                next_state = STATE_D;
            end
        end
        STATE_B: begin
            g[0] = 1;
            if (r == 3'b001) begin
                next_state = STATE_B;
            end else begin
                next_state = STATE_A;
            end
        end
        STATE_C: begin
            g[1] = 1;
            if (r == 3'b010) begin
                next_state = STATE_C;
            end else begin
                next_state = STATE_A;
            end
        end
        STATE_D: begin
            if (r == 3'b100) begin
                next_state = STATE_D;
            end else begin
                next_state = STATE_A;
            end
        end
        default: next_state = STATE_A;
    endcase
end

endmodule
