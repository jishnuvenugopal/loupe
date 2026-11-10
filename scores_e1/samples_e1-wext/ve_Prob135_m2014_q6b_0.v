
module TopModule (
    input wire y [2:0],
    input wire w,
    output reg Y1
);

    
    parameter A = 3'b000,
             B = 3'b001,
             C = 3'b010,
             D = 3'b011,
             E = 3'b100,
             F = 3'b101;

    
    reg [2:0] state;
    reg [2:0] next_state;

    
    always @(*) begin
        state = A;
    end

    
    always @(posedge w or negedge y) begin
        case (state)
            A: begin
                if (w == 1'b0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (w == 1'b0) begin
                    next_state = C;
                end else begin
                    next_state = D;
                end
            end
            C: begin
                if (w == 1'b0) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            D: begin
                if (w == 1'b0) begin
                    next_state = F;
                end else begin
                    next_state = A;
                end
            end
            E: begin
                if (w == 1'b0) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            F: begin
                if (w == 1'b0) begin
                    next_state = C;
                end else begin
                    next_state = D;
                end
            end
            default: begin
                next_state = A;
            end
        endcase

        
        state <= next_state;

        
        Y1 <= state[1];
    end

endmodule
