
module TopModule (
    input  clk,
    input  load,
    input  ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    
    typedef enum {IDLE, LOAD, SHIFT_LEFT_1, SHIFT_LEFT_8, SHIFT_RIGHT_1, SHIFT_RIGHT_8} state_t;
    state_t current_state, next_state;

    
    reg [63:0] shift_register;

    
    always @(posedge clk) begin
        current_state <= next_state;
    end

    
    always @(*) begin
        next_state = IDLE;
        case (current_state)
            IDLE: begin
                if (load) begin
                    next_state = LOAD;
                end else if (ena) begin
                    case (amount)
                        2'b00: next_state = SHIFT_LEFT_1;
                        2'b01: next_state = SHIFT_LEFT_8;
                        2'b10: next_state = SHIFT_RIGHT_1;
                        2'b11: next_state = SHIFT_RIGHT_8;
                    endcase
                end
            end
            LOAD: begin
                next_state = IDLE;
            end
            SHIFT_LEFT_1: begin
                next_state = IDLE;
            end
            SHIFT_LEFT_8: begin
                next_state = IDLE;
            end
            SHIFT_RIGHT_1: begin
                next_state = IDLE;
            end
            SHIFT_RIGHT_8: begin
                next_state = IDLE;
            end
        endcase
    end

    
    always @(posedge clk) begin
        case (current_state)
            LOAD: begin
                shift_register <= data;
            end
            SHIFT_LEFT_1: begin
                shift_register <= {shift_register[62:0], shift_register[63]};
            end
            SHIFT_LEFT_8: begin
                shift_register <= {shift_register[55:0], shift_register[63:56]};
            end
            SHIFT_RIGHT_1: begin
                shift_register <= {shift_register[1:0], shift_register[63:1]};
            end
            SHIFT_RIGHT_8: begin
                shift_register <= {shift_register[7:0], shift_register[63:8]};
            end
            default: begin
                shift_register <= shift_register;
            end
        endcase
    end

    
    assign q = shift_register;

endmodule
