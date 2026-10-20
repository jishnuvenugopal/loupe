
module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    
    localparam A = 3'b000,
               B = 3'b001,
               C = 3'b010,
               D = 3'b011,
               E = 3'b100,
               F = 3'b101;

    
    reg [2:0] state, next_state;

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    
    always @(*) begin
        next_state = A;
        g = 3'b000;

        case (state)
            A: begin
                if (r == 3'b000)
                    next_state = A;
                else if (r[0] == 1'b1)
                    next_state = B;
                else if (r[1] == 1'b1)
                    next_state = C;
                else if (r[2] == 1'b1)
                    next_state = E;
            end
            B: begin
                if (r[0] == 1'b1)
                    next_state = B;
                else
                    next_state = A;
                g[0] = 1'b1;
            end
            C: begin
                if (r[1] == 1'b1)
                    next_state = C;
                else
                    next_state = A;
                g[1] = 1'b1;
            end
            D: begin
                if (r == 3'b000)
                    next_state = D;
                else
                    next_state = F;
            end
            E: begin
                if (r[2] == 1'b1)
                    next_state = E;
                else
                    next_state = A;
                g[2] = 1'b1;
            end
            F: begin
                if (r[2] == 1'b1)
                    next_state = F;
                else
                    next_state = A;
                g[2] = 1'b1;
            end
            default: next_state = A;
        endcase
    end

endmodule
