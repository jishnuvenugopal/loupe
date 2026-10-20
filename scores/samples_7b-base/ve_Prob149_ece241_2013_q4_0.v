
module TopModule(
    input wire clk,
    input wire reset,
    input wire [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);


typedef enum reg [1:0] {
    IDLE,
    BETWEEN_S2_S1,
    BETWEEN_S1_S0,
    BELOW_S0
} state_type;

state_type current_state, next_state;


reg [2:0] prev_s;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
        fr2 <= 1;
        fr1 <= 1;
        fr0 <= 1;
        dfr <= 0;
        prev_s <= 3'b111;
    end else begin
        current_state <= next_state;
        fr2 <= 1 ^ (current_state == BETWEEN_S1_S0);
        fr1 <= 1 ^ (current_state == IDLE || current_state == BETWEEN_S2_S1);
        fr0 <= (current_state == IDLE || current_state == BETWEEN_S1_S0 || current_state == BETWEEN_S2_S1);
        dfr <= (current_state == BETWEEN_S1_S0) && (prev_s != s);
    end
end

always @(*) begin
    case (current_state)
        IDLE: begin
            next_state = (s == 3'b000) ? IDLE : (s == 3'b001) ? BETWEEN_S2_S1 : (s == 3'b010) ? BETWEEN_S1_S0 : BELOW_S0;
        end
        BETWEEN_S2_S1: begin
            next_state = (s == 3'b000) ? IDLE : (s == 3'b001) ? BETWEEN_S2_S1 : (s == 3'b010) ? BETWEEN_S1_S0 : BELOW_S0;
        end
        BETWEEN_S1_S0: begin
            next_state = (s == 3'b000) ? IDLE : (s == 3'b001) ? BETWEEN_S2_S1 : (s == 3'b010) ? BETWEEN_S1_S0 : BELOW_S0;
        end
        BELOW_S0: begin
            next_state = (s == 3'b000) ? IDLE : (s == 3'b001) ? BETWEEN_S2_S1 : (s == 3'b010) ? BETWEEN_S1_S0 : BELOW_S0;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end


always @(posedge clk or posedge reset) begin
    if (reset) begin
        prev_s <= 3'b111;
    end else begin
        prev_s <= s;
    end
end

endmodule
