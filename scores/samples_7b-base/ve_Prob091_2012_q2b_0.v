
module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    
    reg [1:0] state;
 

    
    always @(*) begin
        if (y[5:2] == 4'b0001) state = 2'b00;
 
        else if (y[5:2] == 4'b0010) state = 2'b01;
 
        else if (y[5:2] == 4'b0100) state = 2'b10;
 
        else if (y[5] == 1'b1) state = 2'b11;
 
    end

    
    assign Y1 = (state == 2'b00);
 
    assign Y3 = (state == 2'b10);
 

endmodule
