
module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        STATE1 = 2'b01,
        STATE2 = 2'b10
    } state_t;

    state_t state_next;
    state_t state_reg;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state_reg <= IDLE;
        end else begin
            state_reg <= state_next;
        end
    end

    always @(*) begin
        state_next = state_reg;
        z = 1'b0;
        case (state_reg)
            IDLE:
                if (x == 1'b1) begin
                    state_next = STATE1;
                end
            STATE1:
                if (x == 1'b0) begin
                    state_next = STATE2;
                end
            STATE2:
                if (x == 1'b1) begin
                    state_next = IDLE;
                    z = 1'b1;
                end
        endcase
    end

endmodule
