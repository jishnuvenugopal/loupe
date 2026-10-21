
module TopModule (
    input wire [5:0] y,
    input wire w,
    output reg Y1,
    output reg Y3
);

    
    reg [1:0] y;

    
    always @(posedge w or posedge y[5:0]) begin
        case (y[5:0])
            6'b000001: begin
                y <= 2'b01;
                Y1 <= 1'b1;
                Y3 <= 1'b0;
            end
            6'b000010: begin
                y <= 2'b10;
                Y1 <= 1'b0;
                Y3 <= 1'b1;
            end
            6'b000100: begin
                y <= 2'b11;
                Y1 <= 1'b1;
                Y3 <= 1'b0;
            end
            6'b001000: begin
                y <= 2'b00;
                Y1 <= 1'b0;
                Y3 <= 1'b1;
            end
            6'b010000: begin
                y <= 2'b10;
                Y1 <= 1'b0;
                Y3 <= 1'b1;
            end
            6'b100000: begin
                y <= 2'b01;
                Y1 <= 1'b1;
                Y3 <= 1'b0;
            end
            default: begin
                y <= 2'b00;
                Y1 <= 1'b0;
                Y3 <= 1'b0;
            end
        endcase
    end

endmodule
