
module TopModule (
    input wire y[3:0],
    input wire w,
    output reg Y1
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t state = A;
    reg [1:0] y1;

    
    always @(posedge w or posedge y[3:0]) begin
        case (state)
            A: begin
                if (y[3:0] == 4'b0000) begin
                    state = B;
                end else if (y[3:0] == 4'b0001) begin
                    state = A;
                end
            end
            B: begin
                if (y[3:0] == 4'b0000) begin
                    state = C;
                end else if (y[3:0] == 4'b0001) begin
                    state = D;
                end
            end
            C: begin
                if (y[3:0] == 4'b0000) begin
                    state = E;
                end else if (y[3:0] == 4'b0001) begin
                    state = D;
                end
            end
            D: begin
                if (y[3:0] == 4'b0000) begin
                    state = F;
                end else if (y[3:0] == 4'b0001) begin
                    state = A;
                end
            end
            E: begin
                if (y[3:0] == 4'b0000) begin
                    state = E;
                end else if (y[3:0] == 4'b0001) begin
                    state = D;
                end
            end
            F: begin
                if (y[3:0] == 4'b0000) begin
                    state = C;
                end else if (y[3:0] == 4'b0001) begin
                    state = D;
                end
            end
        endcase
    end

    
    always @(posedge w or posedge y[3:0]) begin
        case (state)
            A: Y1 = 0;
            B: Y1 = 0;
            C: Y1 = 1;
            D: Y1 = 0;
            E: Y1 = 1;
            F: Y1 = 0;
        endcase
    end

endmodule
