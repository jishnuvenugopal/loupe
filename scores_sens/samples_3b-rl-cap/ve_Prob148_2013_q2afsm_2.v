
module TopModule (
    input        clk,
    input        resetn,
    input [2:0]  r,    
    output reg [2:0] g 
);

    
    typedef enum {A, B, C, D} state_t;
    reg state;

    
    always @(*) begin
        case (state)
            A: begin
                g = 3'b000;
            end
            B: begin
                g = 3'b001;
            end
            C: begin
                g = 3'b010;
            end
            D: begin
                g = 3'b100;
            end
            default: begin
                g = 3'b000;
            end
        endcase
    end

    
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (r == 3'b000) begin
                        state <= A;
                    end else begin
                        state <= (r[0] | r[1]) ? B : C;
                    end
                end
                B: begin
                    if (r[0]) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                C: begin
                    if (r[1]) begin
                        state <= C;
                    end else begin
                        state <= A;
                    end
                end
                D: begin
                    if (r[2]) begin
                        state <= D;
                    end else begin
                        state <= A;
                    end
                end
                default: begin
                    state <= A;
                end
            endcase
        end
    end

endmodule
