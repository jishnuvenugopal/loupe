
module TopModule (
    input wire y [2:0],
    input wire w,
    output reg Y1
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t state;

    
    always @(posedge w or posedge y) begin
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

    
    assign Y1 = y[1];

endmodule
