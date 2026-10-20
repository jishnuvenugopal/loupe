
module TopModule (
    input  in,          
    output out          
);

    
    assign out = { {24{in[7]}}, in };

endmodule
