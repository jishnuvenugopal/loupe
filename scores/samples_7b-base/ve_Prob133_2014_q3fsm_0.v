
module TopModule (
    input wire clk,
    input wire reset,
    input wire s,
    input wire w,
    output reg z
);

    typedef enum reg [1:0] {
        STATE_A,
        STATE_B
    } state_t;

    state_t currentState, nextState;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            currentState <= STATE_A;
            z <= 0;
        end else begin
            currentState <= nextState;
            if (currentState == STATE_B) begin
                z <= w_state;
            end
        end
    end

    reg [1:0] w_state_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w_state_count <= 2'b00;
            w_state <= 1'b0;
        end else begin
            if (currentState == STATE_B) begin
                if (w_state_count == 2'b00) begin
                    w_state <= w;
                end
                if (w_state_count == 2'b10) begin
                    if (w_state == w) begin
                        w_state_count <= 2'b10;
                    end else begin
                        w_state_count <= 2'b00;
                    end
                end
                w_state_count <= w_state_count + 1;
            end
        end
    end

    always @(*) begin
        case (currentState)
            STATE_A: begin
                if (s) begin
                    nextState = STATE_B;
                end else begin
                    nextState = STATE_A;
                end
            end
            STATE_B: begin
                if (w_state_count == 2'b10) begin
                    nextState = STATE_A;
                end else begin
                    nextState = STATE_B;
                end
            end
        endcase
    end

endmodule
