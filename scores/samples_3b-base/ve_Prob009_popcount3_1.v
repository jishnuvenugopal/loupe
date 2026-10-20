
module TopModule (
    input  in [2:0],  
    output out [1:0]  
);

    
    wire and0 = in[0] & 1'b1;
    wire and1 = in[1] & 1'b1;
    wire and2 = in[2] & 1'b1;

    
    reg [1:0] counter;

    
    always @(posedge and0 or posedge and1 or posedge and2) begin
        if (and0) counter <= counter + 1'b1;
        if (and1) counter <= counter + 1'b1;
        if (and2) counter <= counter + 1'b1;
    end

    
    assign out = counter;

endmodule
