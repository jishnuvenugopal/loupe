
module TopModule (
    input  [7:0] in,  
    output [2:0] pos   
);

    
    assign pos = 3'b000;

    
    if (in[7]) begin
        pos = 3'b100;
    end else if (in[6]) begin
        pos = 3'b010;
    end else if (in[5]) begin
        pos = 3'b001;
    end else if (in[4]) begin
        pos = 3'b0001;
    end else if (in[3]) begin
        pos = 3'b00001;
    end else if (in[2]) begin
        pos = 3'b000001;
    end else if (in[1]) begin
        pos = 3'b0000001;
    end else if (in[0]) begin
        pos = 3'b00000001;
    end

endmodule
