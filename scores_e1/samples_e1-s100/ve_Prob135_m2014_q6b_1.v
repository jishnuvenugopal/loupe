
module TopModule (
    input  wire y [2:0],
    input  wire w,
    output wire Y1
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
                end else begin
                    state_reg <= A;
                end
            end
            B: begin
                if (w == 0) begin
                    state_reg <= C;
                end else begin
                    state_reg <= D;
                end
            end
            C: begin
                if (w == 0) begin
                    state_reg <= E;
                end else begin
                    state_reg <= D;
                end
            end
            D: begin
                if (w == 0) begin
                    state_reg <= F;
                end else begin
                    state_reg <= A;
                end
            end
            E: begin
                if (w == 0) begin
                    state_reg <= E;
                end else begin
                    state_reg <= D;
                end
            end
            F: begin
                if (w == 0) begin
                    state_reg <= C;
                end else begin
                    state_reg <= D;
                end
            end
        endcase
    end

    
    always @(posedge w or posedge state_reg) begin
        case (state_reg)
            A: begin
                y_reg <= 3'b000;
            end
            B: begin
                y_reg <= 3'b001;
            end
            C: begin
                y_reg <= 3'b010;
            end
            D: begin
                y_reg <= 3'b011;
            end
            E: begin
                y_reg <= 3'b100;
            end
            F: begin
                y_reg <= 3'b101;
            end
        endcase
    end

    
    assign state_reg = state;
    assign y_reg = y;
    assign Y1 = y_reg[1];

endmodule
