
module TopModule (
    input  wire c,
    input  wire d,
    output reg  [3:0] mux_in
);

    
    wire a, b, ab0, ab1, ab2, ab3;

    
    assign ab0 = (c & d);
    assign ab1 = (~c & d);
    assign ab2 = (~c & ~d);
    assign ab3 = (c & ~d);
    assign a = ab0 ? c : ab1 ? d : ab2 ? c : ab3 ? d : 1'b0;

    
    assign ab0 = (c & d);
    assign ab1 = (~c & d);
    assign ab2 = (~c & ~d);
    assign ab3 = (c & ~d);
    assign b = ab0 ? d : ab1 ? c : ab2 ? d : ab3 ? c : 1'b0;

    
    assign mux_in[0] = ab0 ? a : ab1 ? b : ab2 ? c : ab3 ? d : 1'b0;
    assign mux_in[1] = ab0 ? a : ab1 ? b : ab2 ? c : ab3 ? d : 1'b0;
    assign mux_in[2] = ab0 ? a : ab1 ? b : ab2 ? c : ab3 ? d : 1'b0;
    assign mux_in[3] = ab0 ? a : ab1 ? b : ab2 ? c : ab3 ? d : 1'b0;

endmodule
