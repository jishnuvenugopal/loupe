
module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);


typedef enum { A, B, C, D, E } state_t;


state_t state;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
 
    end else begin
        case (state)
            A: begin
                if (w) begin
                    state <= B;
 
                end else begin
                    state <= A;
 
                end
            end
            B: begin
                if (w) begin
                    state <= C;
 
                end else begin
                    state <= D;
 
                end
            end
            C: begin
                if (w) begin
                    state <= E;
 
                end else begin
                    state <= D;
 
                end
            end
            D: begin
                if (w) begin
                    state <= F;
 
                end else begin
                    state <= A;
 
                end
            end
            E: begin
                if (w) begin
                    state <= E;
 
                end else begin
                    state <= D;
 
                end
            end
            F: begin
                if (w) begin
                    state <= C;
 
                end else begin
                    state <= D;
 
                end
            end
        endcase
    end
end


always @(*) begin
    case (state)
        A: z = 1'b0;
 
        B: z = 1'b0;
 
        C: z = 1'b0;
 
        D: z = 1'b0;
 
        E: z = 1'b1;
 
        F: z = 1'b0;
 
    endcase
end

endmodule
