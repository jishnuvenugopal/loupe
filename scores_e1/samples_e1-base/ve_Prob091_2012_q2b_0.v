
module TopModule (
    input wire [5:0] y,
    input wire w,
    output reg Y1,
    output reg Y3
);

    
    reg [5:0] state;
    reg [1:0] y1_flipflop;
    reg [1:0] y3_flipflop;

    
    always @(posedge w) begin
        case (state)
            6'b000001: begin
                state = 6'b000010;
                y1_flipflop = 2'b01;
                y3_flipflop = 2'b01;
            end
            6'b000010: begin
                state = 6'b000100;
                y1_flipflop = 2'b00;
                y3_flipflop = 2'b01;
            end
            6'b000100: begin
                state = 6'b001000;
                y1_flipflop = 2'b01;
                y3_flipflop = 2'b00;
            end
            6'b001000: begin
                state = 6'b010000;
                y1_flipflop = 2'b00;
                y3_flipflop = 2'b00;
            end
            6'b010000: begin
                state = 6'b100000;
                y1_flipflop = 2'b01;
                y3_flipflop = 2'b00;
            end
            6'b100000: begin
                state = 6'b000001;
                y1_flipflop = 2'b01;
                y3_flipflop = 2'b01;
            end
        endcase
    end

    
    assign Y1 = y1_flipflop;
    assign Y3 = y3_flipflop;

endmodule
