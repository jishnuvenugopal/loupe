
module TopModule (
    input wire [5:0] y,
    input wire w,
    output reg Y1,
    output reg Y3
);

    
    reg [5:0] state;
    reg y1;
    reg y3;

    
    always @(posedge w) begin
        case (state)
            6'b000001: begin
                state = 6'b000010;
                y1 = 1'b1;
                y3 = 1'b0;
            end
            6'b000010: begin
                state = 6'b000100;
                y1 = 1'b0;
                y3 = 1'b1;
            end
            6'b000100: begin
                state = 6'b001000;
                y1 = 1'b1;
                y3 = 1'b0;
            end
            6'b001000: begin
                state = 6'b010000;
                y1 = 1'b0;
                y3 = 1'b1;
            end
            6'b010000: begin
                state = 6'b100000;
                y1 = 1'b1;
                y3 = 1'b0;
            end
            6'b100000: begin
                state = 6'b000001;
                y1 = 1'b0;
                y3 = 1'b1;
            end
            default: begin
                state = 6'b000001;
                y1 = 1'b1;
                y3 = 1'b0;
            end
        endcase
    end

    
    assign Y1 = state[1];
    assign Y3 = state[3];

endmodule
