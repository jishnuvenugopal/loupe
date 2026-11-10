
module TopModule (
    input wire y [2:0],
    input wire w,
    output reg Y1
);


typedef enum {A, B, C, D, E, F} state_t;


state_t state = A;

always @(posedge w or negedge y) begin
    case (state)
        A: begin
            if (w == 0) begin
                state <= B;
            end else begin
                state <= A;
            end
        end
        B: begin
            if (w == 0) begin
                state <= C;
            end else begin
                state <= D;
            end
        end
        C: begin
            if (w == 0) begin
                state <= E;
            end else begin
                state <= D;
            end
        end
        D: begin
            if (w == 0) begin
                state <= F;
            end else begin
                state <= A;
            end
        end
        E: begin
            if (w == 0) begin
                state <= E;
            end else begin
                state <= D;
            end
        end
        F: begin
            if (w == 0) begin
                state <= C;
            end else begin
                state <= D;
            end
        end
        default: state <= A;
 
    endcase
end


always @(posedge w or negedge y) begin
    case (state)
        A: Y1 <= 0;
        B: Y1 <= 0;
        C: Y1 <= 1;
        D: Y1 <= 0;
        E: Y1 <= 1;
        F: Y1 <= 0;
        default: Y1 <= 0;
 
    endcase
end

endmodule
