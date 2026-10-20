
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    
    parameter A = 3'd0,
              B = 3'd1,
              C = 3'd2,
              C1 = 3'd3,
              C2 = 3'd4,
              G = 3'd5,
              G1 = 3'd6,
              G0 = 3'd7;

    reg [2:0] state, next_state;

    
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    
    always @(*) begin
        case (state)
            A: next_state = B;
            B: next_state = C;
            C: next_state = x ? C1 : C;
            C1: next_state = x ? C : C2;
            C2: next_state = x ? G : C;
            G: next_state = y ? G : G1;
            G1: next_state = y ? G : G0;
            G0: next_state = G0;
            default: next_state = A;
        endcase
    end

    
    assign f = (state == B);
    assign g = (state == G || state == G1);

endmodule
