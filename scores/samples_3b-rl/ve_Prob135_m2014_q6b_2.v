
module TopModule (
    input  wire [2:0] y,    
    input  wire       w,    
    output wire       Y1    
);

    
    reg [2:0] y_reg;
    reg       Y1_reg;

    
    always @(*) begin
        case (y[2:0])
            3'b000: 
                if (w == 1'b0)
                    y_reg[1] = 1'b0;
                else
                    y_reg[1] = 1'b1;
            3'b001: 
                if (w == 1'b0)
                    y_reg[1] = 1'b0;
                else
                    y_reg[1] = 1'b1;
            3'b002: 
                if (w == 1'b0)
                    y_reg[1] = 1'b0;
                else
                    y_reg[1] = 1'b1;
            3'b003: 
                if (w == 1'b0)
                    y_reg[1] = 1'b0;
                else
                    y_reg[1] = 1'b1;
            3'b004: 
                if (w == 1'b0)
                    y_reg[1] = 1'b0;
                else
                    y_reg[1] = 1'b1;
            3'b005: 
                if (w == 1'b0)
                    y_reg[1] = 1'b0;
                else
                    y_reg[1] = 1'b1;
            default: 
                y_reg[1] = 1'b0;
        endcase
    end

    
    always @(*) begin
        case (y[2:0])
            3'b000: 
                if (w == 1'b0)
                    y_reg = 3'b001;
 
                else
                    y_reg = 3'b000;
 
            3'b001: 
                if (w == 1'b0)
                    y_reg = 3'b002;
 
                else
                    y_reg = 3'b000;
 
            3'b002: 
                if (w == 1'b0)
                    y_reg = 3'b003;
 
                else
                    y_reg = 3'b001;
 
            3'b003: 
                if (w == 1'b0)
                    y_reg = 3'b004;
 
                else
                    y_reg = 3'b002;
 
            3'b004: 
                if (w == 1'b0)
                    y_reg = 3'b005;
 
                else
                    y_reg = 3'b003;
 
            3'b005: 
                if (w == 1'b0)
                    y_reg = 3'b000;
 
                else
                    y_reg = 3'b003;
 
            default: 
                y_reg = 3'b000;
 
        endcase
    end

    
    always @(*) begin
        Y1_reg = y_reg[1];
    end

    
    assign Y1 = Y1_reg;

endmodule
