
module TopModule (
    input wire clk,
    input wire [7:0] in,
    output reg anyedge
);

    
    typedef enum {IDLE, TRANSITION} state_t;
    state_t current_state, next_state;

    
    reg [7:0] prev_in;

    
    reg [1:0] state_reg;

    
    reg [7:0] prev_in_reg;

    
    initial begin
        current_state = IDLE;
        state_reg = 2'b00;
        prev_in_reg = 8'b00000000;
    end

    
    always @(posedge clk) begin
        current_state <= next_state;
        prev_in_reg <= prev_in;
    end

    always @(*) begin
        case (current_state)
            IDLE: begin
                if (in == 8'b00000001) begin
                    next_state = TRANSITION;
                end else begin
                    next_state = IDLE;
                end
            end
            TRANSITION: begin
                if (in == 8'b00000000) begin
                    next_state = IDLE;
                end else begin
                    next_state = TRANSITION;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    
    always @(posedge clk) begin
        if (current_state == TRANSITION) begin
            anyedge <= 1'b1;
        end else begin
            anyedge <= 1'b0;
        end
    end

endmodule
