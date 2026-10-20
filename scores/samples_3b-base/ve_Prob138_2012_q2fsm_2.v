
module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);


typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11,
    E = 2'b00,
    F = 2'b11
} state_t;


state_t current_state, next_state;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end


always @(posedge clk) begin
    case (current_state)
        A: begin
            if (w) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
        end
        B: begin
            if (w) begin
                next_state <= C;
            end else begin
                next_state <= D;
            end
        end
        C: begin
            if (w) begin
                next_state <= E;
            end else begin
                next_state <= D;
            end
        end
        D: begin
            if (w) begin
                next_state <= F;
            end else begin
                next_state <= A;
            end
        end
        E: begin
            if (w) begin
                next_state <= E;
            end else begin
                next_state <= D;
            end
        end
        F: begin
            if (w) begin
                next_state <= C;
            end else begin
                next_state <= D;
            end
        end
    endcase
end


always @(*) begin
    case (current_state)
        A: z <= 1'b0;
        B: z <= 1'b0;
        C: z <= 1'b0;
        D: z <= 1'b0;
        E: z <= 1'b1;
        F: z <= 1'b0;
    endcase
end

endmodule
