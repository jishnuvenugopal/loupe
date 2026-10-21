
module TopModule (
    input wire y [2:0],
    input wire w,
    output reg Y1
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t state;

    
    reg [2:0] state_reg;
    reg [1:0] y_reg;

    
    always @(posedge w or posedge y_reg) begin
        case (state_reg)
            A: begin
                if (w == 0) begin
                    state_reg <= B;
                    y_reg <= y[1];
                end else begin
                    state_reg <= A;
                    y_reg <= y[1];
                end
            end
            B: begin
                if (w == 0) begin
                    state_reg <= C;
                    y_reg <= y[1];
                end else begin
                    state_reg <= D;
                    y_reg <= y[1];
                end
            end
            C: begin
                if (w == 0) begin
                    state_reg <= E;
                    y_reg <= y[1];
                end else begin
                    state_reg <= D;
                    y_reg <= y[1];
                end
            end
            D: begin
                if (w == 0) begin
                    state_reg <= F;
                    y_reg <= y[1];
                end else begin
                    state_reg <= A;
                    y_reg <= y[1];
                end
            end
            E: begin
                if (w == 0) begin
                    state_reg <= E;
                    y_reg <= y[1];
                end else begin
                    state_reg <= D;
                    y_reg <= y[1];
                end
            end
            F: begin
                if (w == 0) begin
                    state_reg <= C;
                    y_reg <= y[1];
                end else begin
                    state_reg <= D;
                    y_reg <= y[1];
                end
            end
        endcase
    end

    
    assign state_reg = state;
    assign Y1 = y_reg[1];

endmodule
