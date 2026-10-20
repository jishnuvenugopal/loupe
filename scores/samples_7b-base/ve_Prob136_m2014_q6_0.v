
module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);


parameter State_A = 2'b00,
           State_B = 2'b01,
           State_C = 2'b10,
           State_D = 2'b11,
           State_E = 2'b101,
           State_F = 2'b111;


reg [2:0] currentState;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        currentState <= State_A;
 
    end else begin
        currentState <= nextState;
    end
end

always @(*) begin
    case (currentState)
        State_A: begin
            z = 1'b0;
 
            if (w == 1'b0) nextState = State_B;
            else nextState = State_A;
        end
        State_B: begin
            z = 1'b1;
 
            if (w == 1'b0) nextState = State_C;
            else nextState = State_D;
        end
        State_C: begin
            z = 1'b0;
 
            if (w == 1'b0) nextState = State_E;
            else nextState = State_D;
        end
        State_D: begin
            z = 1'b1;
 
            if (w == 1'b0) nextState = State_F;
            else nextState = State_A;
        end
        State_E: begin
            z = 1'b1;
 
            if (w == 1'b0) nextState = State_E;
            else nextState = State_D;
        end
        State_F: begin
            z = 1'b0;
 
            if (w == 1'b0) nextState = State_C;
            else nextState = State_D;
        end
        default: nextState = State_A;
 
    endcase
end

endmodule
