
module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);
    
    typedef enum logic [1:0] {
        IDLE,
        DETECT_PATTERNS,
        READ_DELAY,
        COUNTING,
        DONE_WAITING
    } state_t;

    state_t state, next_state;

    logic [3:0] delay;
    logic [3:0] counter;
    logic [3:0] remaining;

    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            if (state == IDLE) begin
                if (data == 1'b1) begin
                    state <= DETECT_PATTERNS;
                end
            end else if (state == DETECT_PATTERNS) begin
                if (data == 1'b1) begin
                    state <= DETECT_PATTERNS;
                end else if (data == 1'b0) begin
                    state <= READ_DELAY;
                end else begin
                    state <= IDLE;
                end
            end else if (state == READ_DELAY) begin
                state <= COUNTING;
            end else if (state == COUNTING) begin
                state <= DONE_WAITING;
            end else if (state == DONE_WAITING) begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                end
            end
        end
    end

    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            delay <= 4'b0000;
        end else begin
            if (state == READ_DELAY) begin
                delay <= {data, delay[3:1]};
            end
        end
    end

    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0;
            remaining <= 4'b0;
            counting <= 1'b0;
        end else begin
            if (state == COUNTING) begin
                counter <= counter + 1;
                remaining <= delay - counter;
                counting <= 1'b1;
            end else if (state == DONE_WAITING) begin
                counting <= 1'b0;
            end
        end
    end

    
    always_comb begin
        if (state == COUNTING) begin
            count = remaining;
        end else begin
            count = 4'b0000;
        end
    end

    always_comb begin
        done = (state == DONE_WAITING);
    end
endmodule
