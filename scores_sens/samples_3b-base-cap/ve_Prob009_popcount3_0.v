
module TopModule (
    input  [2:0] in,  
    output [1:0] out   
);

    
    wire a1 = in[0] & in[1];
    wire a2 = in[0] & in[2];
    wire a3 = in[1] & in[2];

    
    reg [1:0] count;

    
    always @(posedge a1 or posedge a2 or posedge a3) begin
        if (a1) count <= count + 1;
        if (a2) count <= count + 1;
        if (a3) count <= count + 1;
    end

    
    assign out = count;

endmodule
