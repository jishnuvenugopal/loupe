
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5,
               G = 3'd6,
               H = 3'd7;

    reg [2:0] state, next_state;

    
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    
    always @(*) begin
        case (state)
            A: next_state = resetn ? B : A;
            B: next_state = x ? C : B;
            C: next_state = ~x ? D : B;
            D: next_state = x ? E : B;
            E: next_state = F;
            F: next_state = y ? E : G;
            G: next_state = y ? E : H;
            H: next_state = H;
            default: next_state = A;
        endcase
    end

    
    assign f = (state == B);
    assign g = (state == E) || (state == F) || (state == G);

endmodule
