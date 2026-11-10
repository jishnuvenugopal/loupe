
module TopModule (
    input wire clk,
    input wire resetn,
    input wire [2:0] r,
    output reg [2:0] g
);

    
    parameter A = 3'b000,
            B = 3'b001,
            C = 3'b010,
            D = 3'b011;

    
    reg [2:0] state;

    
    reg [2:0] next_state;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            state <= A;
            next_state <= A;
        end else begin
            case (state)
                A: begin
                    if (r == A) begin
                        next_state <= A;
                    end else begin
                        next_state <= B;
                    end
                end
                B: begin
                    if (r == B) begin
                        next_state <= B;
                    end else begin
                        next_state <= A;
                    end
                end
                C: begin
                    if (r == C) begin
                        next_state <= C;
                    end else begin
                        next_state <= A;
                    end
                end
                D: begin
                    if (r == D) begin
                        next_state <= D;
                    end else begin
                        next_state <= A;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            g <= 3'b000;
        end else begin
            case (state)
                A: begin
                    g <= 3'b000;
                end
                B: begin
                    g <= 3'b001;
                end
                C: begin
                    g <= 3'b010;
                end
                D: begin
                    g <= 3'b011;
                end
            endcase
        end
    end

endmodule
