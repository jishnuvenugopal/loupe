
module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    
    reg [31:0] serial_in;

    always @(posedge clk) begin
        if (areset) begin
            serial_in <= 0;
            z <= 0;
        end else begin
            
            serial_in <= {serial_in[30:0], x};

            
            z <= ~serial_in + 1;
        end
    end

endmodule
