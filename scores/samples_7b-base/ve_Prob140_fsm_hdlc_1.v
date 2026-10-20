
module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    
    parameter IDLE = 3'b000,
               ONE  = 3'b001,
               TWO  = 3'b010,
               THREE = 3'b011,
               FOUR = 3'b100,
               FIVE = 3'b101,
               SIX = 3'b110;

    reg [2:0] state, next_state;
    reg [2:0] one_count;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            one_count <= 0;
        end else begin
            state <= next_state;
            if (in == 1) begin
                one_count <= one_count + 1;
            end else begin
                one_count <= 0;
            end
        end
    end

    
    always @(*) begin
        next_state = state;
        disc = 0;
        flag = 0;
        err = 0;

        case (state)
            IDLE:
                if (in == 1) begin
                    next_state = ONE;
                end
            ONE:
                if (in == 1) begin
                    next_state = TWO;
                end else begin
                    next_state = IDLE;
                end
            TWO:
                if (in == 1) begin
                    next_state = THREE;
                end else begin
                    next_state = IDLE;
                end
            THREE:
                if (in == 1) begin
                    next_state = FOUR;
                end else begin
                    next_state = IDLE;
                end
            FOUR:
                if (in == 1) begin
                    next_state = FIVE;
                end else begin
                    next_state = IDLE;
                end
            FIVE:
                if (in == 1) begin
                    next_state = SIX;
                end else begin
                    next_state = IDLE;
                end
            SIX:
                if (in == 0) begin
                    disc = 1;
                    next_state = IDLE;
                    flag = 1;
                end else if (in == 1) begin
                    disc = 1;
                    next_state = IDLE;
                    err = 1;
                end
        endcase
    end

    
    always @(posedge clk) begin
        if (err) begin
            err <= 0;
        end
        if (disc) begin
            disc <= 0;
        end
        if (flag) begin
            flag <= 0;
        end
    end

endmodule
