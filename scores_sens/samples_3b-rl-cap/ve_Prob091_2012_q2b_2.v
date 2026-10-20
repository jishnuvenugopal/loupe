
module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    
    assign Y1 = y[1];
    assign Y3 = y[3];

    
    reg [5:0] state;
    always @(*) begin
        case (y)
            6'b000001: state = (w) ? 6'b000010 : 6'b000001;
 
            6'b000010: state = (w) ? 6'b000100 : 6'b000010;
 
            6'b000100: state = (w) ? 6'b001000 : 6'b000100;
 
            6'b001000: state = (w) ? 6'b010000 : 6'b001000;
 
            6'b010000: state = (w) ? 6'b100000 : 6'b010000;
 
            6'b100000: state = (w) ? 6'b000100 : 6'b010000;
 
            default: state = 6'b000001;
 
        endcase
    end

    
    reg [5:0] state_reg;
    always @(posedge w) begin
        state_reg <= state;
    end

    
    
    

endmodule
