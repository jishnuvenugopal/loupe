
module TopModule (
    input wire [5:0] y,
    input wire w,
    output reg Y1,
    output reg Y3
);

    
    always @(posedge y or posedge w) begin
        case (y[5:0])
            6'b000001: begin
                Y1 <= 1'b0;
                Y3 <= 1'b0;
            end
            6'b000010: begin
                Y1 <= 1'b1;
                Y3 <= 1'b0;
            end
            6'b000100: begin
                Y1 <= 1'b0;
                Y3 <= 1'b1;
            end
            6'b001000: begin
                Y1 <= 1'b1;
                Y3 <= 1'b1;
            end
            6'b010000: begin
                Y1 <= 1'b0;
                Y3 <= 1'b0;
            end
            6'b100000: begin
                Y1 <= 1'b1;
                Y3 <= 1'b0;
            end
            default: begin
                Y1 <= 1'b0;
                Y3 <= 1'b0;
            end
        endcase
    end

endmodule
