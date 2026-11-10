
module TopModule (
    input wire y [5:0],
    input wire w,
    output reg Y1,
    output reg Y3
);

    
    reg [5:0] state;

    
    always @(posedge w) begin
        case (state)
            6'b000001: state <= 6'b000010;
            6'b000010: state <= 6'b000100;
            6'b000100: state <= 6'b001000;
            6'b001000: state <= 6'b010000;
            6'b010000: state <= 6'b100000;
            6'b100000: state <= 6'b000001;
            default: state <= 6'b000001;
        endcase
    end

    
    assign Y1 = state[1];
    assign Y3 = state[3];

endmodule
