
module TopModule (input clk, reset, w, output z);
    reg [2:0] current_state, next_state;
    parameter A = 0,
              B = 1,
              C = 2,
              D = 3,
              E = 4,
              F = 5;
    
    assign z = (current_state == E) || (current_state == F);
    
    always @(posedge clk)
        if (reset)
            current_state <= A;
        else 
            current_state <= next_state;
    
    always @*
        begin
            case (current_state)
                A: next_state = w ? A : B;
                B: next_state = w ? D : C;
                C: next_state = w ? D : E;
                D: next_state = w ? A : F;
                E: next_state = w ? D : E;
                F: next_state = w ? D : C;
                default: next_state = A;
            endcase
        end
endmodule
