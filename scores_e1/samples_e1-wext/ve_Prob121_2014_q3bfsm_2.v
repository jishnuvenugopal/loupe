
module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    
    reg [2:0] y;

    
    initial begin
        y = 3'b000;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 3'b000;
        end else begin
            case (y)
                3'b000: begin
                    if (x == 0) begin
                        y <= 3'b001;
                    end else begin
                        y <= 3'b001;
                    end
                end
                3'b001: begin
                    if (x == 0) begin
                        y <= 3'b001;
                    end else begin
                        y <= 3'b100;
                    end
                end
                3'b010: begin
                    if (x == 0) begin
                        y <= 3'b010;
                    end else begin
                        y <= 3'b001;
                    end
                end
                3'b011: begin
                    if (x == 0) begin
                        y <= 3'b001;
                    end else begin
                        y <= 3'b010;
                    end
                end
                3'b100: begin
                    if (x == 0) begin
                        y <= 3'b011;
                    end else begin
                        y <= 3'b100;
                    end
                end
            endcase
        end
    end

    
    always @(*) begin
        z = (y == 3'b001) ? 1'b1 : 1'b0;
    end

endmodule
