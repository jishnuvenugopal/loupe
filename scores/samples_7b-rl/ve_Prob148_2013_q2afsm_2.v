
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [1:0] current_state, next_state;

    
    localparam [1:0] 
        State_A = 2'b00,
        State_B = 2'b01,
        State_C = 2'b10,
        State_D = 2'b11;

    
    always @* begin
        case (current_state)
            State_A: begin
                
                if (r[0])
                    next_state = State_B;
                else if (r[1])
                    next_state = State_C;
                else if (r[2])
                    next_state = State_D;
                else 
                    next_state = State_A;
            end
            State_B: 
                next_state = (r[0]) ? State_B : State_A;
            State_C: 
                next_state = (r[1]) ? State_C : State_A;
            State_D: 
                next_state = (r[2]) ? State_D : State_A;
            default: 
                next_state = State_A;
        endcase
    end

    
    assign g = (current_state == State_B) ? 3'b001 :
               (current_state == State_C) ? 3'b010 :
               (current_state == State_D) ? 3'b100 :
               3'b000;

    
    always @(posedge clk) begin
        if (~resetn)
            current_state <= State_A;
        else
            current_state <= next_state;
    end

endmodule
