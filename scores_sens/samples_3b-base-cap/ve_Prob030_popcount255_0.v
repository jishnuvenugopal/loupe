
module TopModule (
    input  [255:0] in,  
    output [7:0] out   
);

    
    reg [7:0] count;
  
    reg [247:0] shifted_in;
  

    
    always @(posedge in[255]) begin
        shifted_in <= {in[254:0], 1'b0};
    end

    
    always @(posedge in[255]) begin
        count <= count + shifted_in[255];
    end

    
    assign out = count;

endmodule
