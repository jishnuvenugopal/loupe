
module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    
    reg [2:0] y0, y1, y2;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y0 <= 3'b000;
            y1 <= 3'b000;
            y2 <= 3'b000;
        end else begin
            case (y0)
                3'b000: begin
                    if (x == 0) begin
                        y0 <= 3'b001;
                        y1 <= 3'b001;
                        y2 <= 3'b001;
                    end else begin
                        y0 <= 3'b001;
                        y1 <= 3'b100;
                        y2 <= 3'b001;
                    end
                end
                3'b001: begin
                    if (x == 0) begin
                        y0 <= 3'b001;
                        y1 <= 3'b010;
                        y2 <= 3'b001;
                    end else begin
                        y0 <= 3'b001;
                        y1 <= 3'b011;
                        y2 <= 3'b100;
                    end
                end
                3'b010: begin
                    if (x == 0) begin
                        y0 <= 3'b010;
                        y1 <= 3'b001;
                        y2 <= 3'b001;
                    end else begin
                        y0 <= 3'b010;
                        y1 <= 3'b010;
                        y2 <= 3'b001;
                    end
                end
                3'b011: begin
                    if (x == 0) begin
                        y0 <= 3'b011;
                        y1 <= 3'b011;
                        y2 <= 3'b010;
                    end else begin
                        y0 <= 3'b011;
                        y1 <= 3'b100;
                        y2 <= 3'b100;
                    end
                end
                3'b100: begin
                    if (x == 0) begin
                        y0 <= 3'b100;
                        y1 <= 3'b100;
                        y2 <= 3'b100;
                    end else begin
                        y0 <= 3'b100;
                        y1 <= 3'b100;
                        y2 <= 3'b100;
                    end
                end
            endcase
        end
    end

    
    assign z = y2;

endmodule
