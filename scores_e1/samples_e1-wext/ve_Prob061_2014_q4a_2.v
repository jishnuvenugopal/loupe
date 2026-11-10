
module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

    
    reg [7:0] shift_register;

    
    always @(posedge clk) begin
        if (E) begin
            if (R) begin
                shift_register <= w;
            end else if (L) begin
                shift_register <= {shift_register[7:0], 1'b0};
            end else begin
                shift_register <= {shift_register[6:0], shift_register[7]};
            end
        end
    end

    
    assign Q = shift_register[0];

endmodule
