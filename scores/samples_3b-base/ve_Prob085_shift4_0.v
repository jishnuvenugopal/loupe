
module TopModule (
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

    
    reg [3:0] shift_register;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_register <= 4'b0;
        end
    end

    
    always @(posedge clk or posedge load) begin
        if (load) begin
            shift_register <= data;
        end
    end

    
    always @(posedge clk or posedge ena) begin
        if (ena) begin
            shift_register <= {shift_register[2:0], shift_register[3]};
        end
    end

    
    assign q = shift_register;

endmodule
