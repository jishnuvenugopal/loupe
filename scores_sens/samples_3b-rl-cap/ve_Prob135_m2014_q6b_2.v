
module TopModule (
    input  wire [2:0] y,   
    input  wire       w,   
    output wire       Y1   
);

    
    reg [2:0] state;
       
    reg       y1_next;
     

    
    always @(*) begin
        case (state)
            3'b000: y1_next = (w == 1'b0) ? 1'b0 : 1'b1;
            3'b001: y1_next = (w == 1'b0) ? 1'b0 : 1'b1;
            3'b010: y1_next = (w == 1'b0) ? 1'b0 : 1'b1;
            3'b011: y1_next = (w == 1'b0) ? 1'b0 : 1'b1;
            3'b100: y1_next = (w == 1'b0) ? 1'b0 : 1'b1;
            3'b101: y1_next = (w == 1'b0) ? 1'b0 : 1'b1;
            default: y1_next = 1'b0;
        endcase
    end

    
    always @(*) begin
        case (state)
            3'b000: if (w == 1'b0) state = 3'b001;
 else state = 3'b000;
            3'b001: if (w == 1'b0) state = 3'b010;
 else state = 3'b000;
            3'b010: if (w == 1'b0) state = 3'b011;
 else state = 3'b010;
            3'b011: if (w == 1'b0) state = 3'b100;
 else state = 3'b011;
            3'b100: if (w == 1'b0) state = 3'b101;
 else state = 3'b100;
            3'b101: if (w == 1'b0) state = 3'b000;
 else state = 3'b101;
            default: state = 3'b000;
        endcase
    end

    
    assign Y1 = y1_next;

endmodule
