
module TopModule (
    input wire clk,
    input wire resetn,
    input wire [2:0] r,
    output reg [2:0] g
);

    
    typedef enum {A, B, C, D} state_t;

    
    state_t current_state = A;
    reg [2:0] next_state;

    
    reg [2:0] state_reg;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            state_reg <= A;
            next_state <= A;
        end else begin
            case (current_state)
                A: begin
                    if (r[0] == 1) begin
                        next_state <= B;
                    end else if (r[1] == 1) begin
                        next_state <= C;
                    end else if (r[2] == 1) begin
                        next_state <= D;
                    end else begin
                        next_state <= A;
                    end
                end
                B: begin
                    if (r[0] == 1) begin
                        next_state <= B;
                    end else if (r[1] == 1) begin
                        next_state <= A;
                    end else if (r[2] == 1) begin
                        next_state <= D;
                    end else begin
                        next_state <= A;
                    end
                end
                C: begin
                    if (r[0] == 1) begin
                        next_state <= B;
                    end else if (r[1] == 1) begin
                        next_state <= A;
                    end else if (r[2] == 1) begin
                        next_state <= D;
                    end else begin
                        next_state <= A;
                    end
                end
                D: begin
                    if (r[0] == 1) begin
                        next_state <= B;
                    end else if (r[1] == 1) begin
                        next_state <= A;
                    end else if (r[2] == 1) begin
                        next_state <= D;
                    end else begin
                        next_state <= A;
                    end
                end
            endcase
            state_reg <= next_state;
        end
    end

    
    assign g = state_reg;

endmodule
