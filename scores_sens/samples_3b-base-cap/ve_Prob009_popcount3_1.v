
module TopModule (
    input  in [2:0],  
    output out [1:0]   
);

    
    reg [1:0] count;

    
    wire and0 = in[0] & in[1];
    wire and1 = in[0] & in[2];
    wire and2 = in[1] & in[2];

    
    always @(and0 or and1 or and2) begin
        if (and0) count <= count + 1;
        if (and1) count <= count + 1;
        if (and2) count <= count + 1;
    end

    
    assign out = count;

endmodule
