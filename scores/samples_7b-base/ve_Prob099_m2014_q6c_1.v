
module TopModule(input [7:0] y, input w, output Y1, output Y3);
    reg [5:0] state, next_state;

    
    parameter A = 6'b000001, B = 6'b000010, C = 6'b000100, 
                      D = 6'b001000, E = 6'b010000, F = 6'b100000;

    
    assign Y1 = y[1];
    assign Y3 = y[3];

    
    always @(*) begin
        case (state)
            A: if (w) next_state = A;
 else next_state = B;
            B: if (w) next_state = D;
 else next_state = C;
            C: if (w) next_state = D;
 else next_state = E;
            D: if (w) next_state = A;
 else next_state = F;
            E: if (w) next_state = D;
 else next_state = E;
            F: if (w) next_state = C;
 else next_state = D;
            default: next_state = A;
  
        endcase
    end

    
    always @(posedge w or posedge y[7]) begin
        if (y[7])  
            state <= A;
        else if (w)
            state <= next_state;
    end
endmodule
