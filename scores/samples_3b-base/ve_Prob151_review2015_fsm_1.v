
module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    
    typedef enum logic [2:0] {
        IDLE,
        START_SEARCH,
        SHIFT_ENA,
        COUNTING,
        DONE
    } state_t;

    
    state_t current_state, next_state;

    
    reg [3:0] shift_reg;

    
    reg [3:0] counter;

    
    localparam START_PATTERN = 4'b1101;

    
    initial begin
        current_state = IDLE;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_reg <= 4'b0;
            counter <= 4'b0;
        end else begin
            current_state <= next_state;
            
            if (current_state == START_SEARCH) begin
                if (data == START_PATTERN) begin
                    shift_reg <= 4'b0;
                    next_state <= SHIFT_ENA;
                end
            end else if (current_state == SHIFT_ENA) begin
                if (counter < 4) begin
                    shift_reg <= {shift_reg[3:0], data};
                    counter <= counter + 1;
                end else begin
                    next_state <= COUNTING;
                end
            end else if (current_state == COUNTING) begin
                if (done_counting) begin
                    next_state <= DONE;
                end
            end else if (current_state == DONE) begin
                if (ack) begin
                    next_state <= IDLE;
                end
            end
        end
    end

    
    assign shift_ena = (current_state == SHIFT_ENA);
    assign counting = (current_state == COUNTING);
    assign done = (current_state == DONE);

endmodule
