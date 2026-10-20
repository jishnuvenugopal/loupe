
module TopModule (
    input  x,
    input  [2:0] y,
    output reg Y0,
    output reg z
);

    
    typedef enum {STATE_000, STATE_001, STATE_010, STATE_011, STATE_100} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = STATE_000;
    end

    
    always @(posedge x or posedge y) begin
        case (current_state)
            STATE_000: begin
                if (x == 0) next_state = y[2:0] == 3'b000 ? STATE_000 : y[2:0] == 3'b001 ? STATE_001 : y[2:0] == 3'b010 ? STATE_010 : y[2:0] == 3'b011 ? STATE_011 : y[2:0] == 3'b100 ? STATE_100 : STATE_000;
                else next_state = y[2:0] == 3'b000 ? STATE_001 : y[2:0] == 3'b001 ? STATE_000 : y[2:0] == 3'b010 ? STATE_011 : y[2:0] == 3'b011 ? STATE_010 : y[2:0] == 3'b100 ? STATE_000 : STATE_001;
            end
            STATE_001: begin
                if (x == 0) next_state = y[2:0] == 3'b000 ? STATE_001 : y[2:0] == 3'b001 ? STATE_000 : y[2:0] == 3'b010 ? STATE_011 : y[2:0] == 3'b011 ? STATE_010 : y[2:0] == 3'b100 ? STATE_100 : STATE_001;
                else next_state = y[2:0] == 3'b000 ? STATE_000 : y[2:0] == 3'b001 ? STATE_001 : y[2:0] == 3'b010 ? STATE_010 : y[2:0] == 3'b011 ? STATE_011 : y[2:0] == 3'b100 ? STATE_001 : STATE_000;
            end
            STATE_010: begin
                if (x == 0) next_state = y[2:0] == 3'b000 ? STATE_010 : y[2:0] == 3'b001 ? STATE_011 : y[2:0] == 3'b010 ? STATE_000 : y[2:0] == 3'b011 ? STATE_001 : y[2:0] == 3'b100 ? STATE_100 : STATE_010;
                else next_state = y[2:0] == 3'b000 ? STATE_001 : y[2:0] == 3'b001 ? STATE_010 : y[2:0] == 3'b010 ? STATE_011 : y[2:0] == 3'b011 ? STATE_000 : y[2:0] == 3'b100 ? STATE_010 : STATE_001;
            end
            STATE_011: begin
                if (x == 0) next_state = y[2:0] == 3'b000 ? STATE_001 : y[2:0] == 3'b001 ? STATE_000 : y[2:0] == 3'b010 ? STATE_011 : y[2:0] == 3'b011 ? STATE_010 : y[2:0] == 3'b100 ? STATE_100 : STATE_001;
                else next_state = y[2:0] == 3'b000 ? STATE_010 : y[2:0] == 3'b001 ? STATE_011 : y[2:0] == 3'b010 ? STATE_000 : y[2:0] == 3'b011 ? STATE_001 : y[2:0] == 3'b100 ? STATE_010 : STATE_001;
            end
            STATE_100: begin
                if (x == 0) next_state = y[2:0] == 3'b000 ? STATE_100 : y[2:0] == 3'b001 ? STATE_001 : y[2:0] == 3'b010 ? STATE_011 : y[2:0] == 3'b011 ? STATE_010 : y[2:0] == 3'b100 ? STATE_000 : STATE_100;
                else next_state = y[2:0] == 3'b000 ? STATE_000 : y[2:0] == 3'b001 ? STATE_010 : y[2:0] == 3'b010 ? STATE_011 : y[2:0] == 3'b011 ? STATE_001 : y[2:0] == 3'b100 ? STATE_010 : STATE_001;
            end
        endcase
    end

    
    always @(posedge x or posedge y) begin
        case (current_state)
            STATE_000: Y0 = y[0];
            STATE_001: Y0 = y[0];
            STATE_010: Y0 = y[0];
            STATE_011: Y0 = y[0];
            STATE_100: Y0 = y[0];
        endcase
    end

    
    always @(posedge x or posedge y) begin
        current_state <= next_state;
    end

endmodule
