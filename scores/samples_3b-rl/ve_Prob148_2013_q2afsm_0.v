
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire [2:0] r,
    output reg  [2:0] g
);

    
    typedef enum {A, B, C, D} state_t;
    state_t state;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            g     <= 3'b000;
        end else begin
            case (state)
                A: begin
                    if (r == 3'b000) begin
                        state <= A;
                        g     <= 3'b000;
                    end else if (r[0]) begin
                        state <= B;
                        g     <= 3'b001;
                    end else if (r[1]) begin
                        state <= C;
                        g     <= 3'b010;
                    end else begin
                        state <= D;
                        g     <= 3'b000;
                    end
                end
                B: begin
                    if (r == 3'b000) begin
                        state <= A;
                        g     <= 3'b000;
                    end else if (r[0]) begin
                        state <= B;
                        g     <= 3'b001;
                    end else begin
                        state <= A;
                        g     <= 3'b000;
                    end
                end
                C: begin
                    if (r == 3'b000) begin
                        state <= A;
                        g     <= 3'b000;
                    end else if (r[1]) begin
                        state <= C;
                        g     <= 3'b010;
                    end else begin
                        state <= A;
                        g     <= 3'b000;
                    end
                end
                D: begin
                    if (r == 3'b000) begin
                        state <= A;
                        g     <= 3'b000;
                    end else begin
                        state <= A;
                        g     <= 3'b000;
                    end
                end
            endcase
        end
    end

endmodule
