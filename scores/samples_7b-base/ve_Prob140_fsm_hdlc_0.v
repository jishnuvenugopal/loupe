
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    typedef enum reg [3:0] state_t {
        IDLE_S0 = 4'b0000,
        ONE_S1 = 4'b0001,
        TWO_ONE_S2 = 4'b0010,
        THREE_ONE_S3 = 4'b0011,
        FOUR_ONE_S4 = 4'b0100,
        FIVE_ONE_S5 = 4'b0101,
        DISCARD_S6 = 4'b0110,
        FLAG_S7 = 4'b0111,
        ERROR_S8 = 4'b1000
    } state_t;

    state_t current_state, next_state;
    reg prev_in;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE_S0;
            prev_in <= 0;
        end else begin
            current_state <= next_state;
            prev_in <= in;
        end
    end

    
    always @(*) begin
        next_state = current_state;
        disc = 0;
        flag = 0;
        err = 0;

        case (current_state)
            IDLE_S0: begin
                if (!prev_in && in) begin
                    next_state = ONE_S1;
                end
            end
            ONE_S1: begin
                next_state = TWO_ONE_S2;
            end
            TWO_ONE_S2: begin
                next_state = THREE_ONE_S3;
            end
            THREE_ONE_S3: begin
                next_state = FOUR_ONE_S4;
            end
            FOUR_ONE_S4: begin
                next_state = FIVE_ONE_S5;
            end
            FIVE_ONE_S5: begin
                if (in) begin
                    next_state = DISCARD_S6;
                end else begin
                    next_state = IDLE_S0;
                    disc = 1;
                end
            end
            DISCARD_S6: begin
                if (in) begin
                    next_state = ERROR_S8;
                end else if (!prev_in && in) begin
                    next_state = FLAG_S7;
                    flag = 1;
                end
            end
            FLAG_S7: begin
                if (!prev_in && in) begin
                    next_state = ERROR_S8;
                end
            end
            ERROR_S8: begin
                
            end
        endcase
    end

endmodule
