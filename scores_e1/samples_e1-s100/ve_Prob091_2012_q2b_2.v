
module TopModule (
    input wire [5:0] y,
    input wire w,
    output reg Y1,
    output reg Y3
);

    
    reg [1:0] state = 2'b00;
 

    
    always @(posedge y[5] or posedge w) begin
        if (w) begin
            case (state)
                2'b00: state = 2'b01;
 
                2'b01: state = 2'b10;
 
                2'b10: state = 2'b11;
 
                2'b11: state = 2'b00;
 
                default: state = state;
 
            endcase
        end
    end

    
    always @(posedge y[5] or posedge w) begin
        case (state)
            2'b00: Y1 = 1'b0;
 
            2'b01: Y1 = 1'b1;
 
            2'b10: Y1 = 1'b0;
 
            2'b11: Y1 = 1'b1;
 
            default: Y1 = 1'b0;
 
        endcase
    end

    always @(posedge y[5] or posedge w) begin
        case (state)
            2'b00: Y3 = 1'b0;
 
            2'b01: Y3 = 1'b1;
 
            2'b10: Y3 = 1'b0;
 
            2'b11: Y3 = 1'b1;
 
            default: Y3 = 1'b0;
 
        endcase
    end

endmodule
