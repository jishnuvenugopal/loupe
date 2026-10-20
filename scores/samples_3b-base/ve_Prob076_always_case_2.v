
module TopModule (
    input  sel,  
    input  [3:0] data0, data1, data2, data3, data4, data5, 
    output out   
);

    
    wire [7:0] control;
    assign control = {data5, data4, data3, data2, data1, data0, 1'b0, 1'b0};

    
    assign out = control[sel];

endmodule
