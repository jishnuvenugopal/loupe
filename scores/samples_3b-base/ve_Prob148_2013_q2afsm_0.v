
module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

    
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;

    
    reg [2:0] state;

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (r == 3'b000) begin
                        state <= A;
                    end else if (r == 3'b001) begin
                        state <= B;
                    end else if (r == 3'b010) begin
                        state <= C;
                    end else if (r == 3'b011) begin
                        state <= D;
                    end
                end
                B: begin
                    if (r == 3'b001) begin
                        state <= B;
                    end else if (r == 3'b000) begin
                        state <= A;
                    end
                end
                C: begin
                    if (r == 3'b011) begin
                        state <= C;
                    end else if (r == 3'b010) begin
                        state <= A;
                    end
                end
                D: begin
                    if (r == 3'b000) begin
                        state <= A;
                    end
                end
            endcase
        end
    end

    
    always @(*) begin
        case (state)
            A: begin
                g = 3'b000;
            end
            B: begin
                if (r[0] == 1) begin
                    g = 3'b001;
                end else begin
                    g = 3'b000;
                end
            end
            C: begin
                if (r[1] == 1) begin
                    g = 3'b010;
                end else begin
                    g = 3'b000;
                end
            end
            D: begin
                g = 3'b000;
            end
        endcase
    end

endmodule
