
module TopModule (
    input wire c,
    input wire d,
    output reg [3:0] mux_in
);

    
    reg [1:0] mux_ab00;
    always @(posedge c or posedge d) begin
        if (c && d) mux_ab00 <= 2'b11;
        else mux_ab00 <= 2'b00;
    end

    
    reg [1:0] mux_ab01;
    always @(posedge c or posedge d) begin
        if (c && ~d) mux_ab01 <= 2'b11;
        else mux_ab01 <= 2'b00;
    end

    
    reg [1:0] mux_ab11;
    always @(posedge c or posedge d) begin
        if (~c && ~d) mux_ab11 <= 2'b11;
        else mux_ab11 <= 2'b00;
    end

    
    reg [1:0] mux_ab10;
    always @(posedge c or posedge d) begin
        if (~c && d) mux_ab10 <= 2'b11;
        else mux_ab10 <= 2'b00;
    end

    
    reg [3:0] mux_in_4to1;
    always @(posedge c or posedge d) begin
        mux_in_4to1 <= {mux_ab00, mux_ab01, mux_ab11, mux_ab10};
    end

endmodule
