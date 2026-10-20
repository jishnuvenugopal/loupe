
module TopModule (
    input  in [2:0],  
    output out [1:0]   
);

    
    reg [1:0] count;

    
    wire and1 = in[0] & in[2];
    wire and2 = in[1] & in[2];

    
    always @(posedge and1 or posedge and2) begin
        if (and1) count <= count + 1;
        if (and2) count <= count + 1;
    end

    
    assign out = count;

endmodule
