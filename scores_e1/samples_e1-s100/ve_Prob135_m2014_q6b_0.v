
module TopModule (
    input wire y[3:0],
    input wire w,
    output reg Y1
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t state;

    
    reg [1:0] state_reg;
    reg [1:0] next_state_reg;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            state_reg <= A;
            next_state_reg <= A;
            Y1 <= 0;
        end else begin
            state_reg <= next_state_reg;
            next_state_reg <= y[1] ? (w == 0) ? A : A : (w == 0) ? B : D;
            Y1 <= state_reg[1];
        end
    end

endmodule
