
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire in,
    output wire out
);

    
    reg [3:0] reg_data;

    
    always @(posedge clk) begin
        if (!resetn) begin
            reg_data <= 4'b0;
        end else begin
            reg_data <= {reg_data[2:0], in, reg_data[3]};
        end
    end

    
    assign out = reg_data[3];

endmodule
