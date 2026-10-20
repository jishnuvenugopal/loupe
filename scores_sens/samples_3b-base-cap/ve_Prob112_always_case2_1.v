
module TopModule (
    input  [3:0] in,  
    output [1:0] pos   
);

    
    localparam [3:0] pos0 = 4'b0001;
    localparam [3:0] pos1 = 4'b0010;
    localparam [3:0] pos2 = 4'b0100;
    localparam [3:0] pos3 = 4'b1000;

    
    wire and0 = in[0];
    wire and1 = in[1];
    wire and2 = in[2];
    wire and3 = in[3];

    
    assign pos = (and3) ? pos3 :
                  (and2) ? pos2 :
                  (and1) ? pos1 :
                  (and0) ? pos0 :
                  2'b00;
  

endmodule
